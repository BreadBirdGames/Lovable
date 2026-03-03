extends Node

## Simple notification handler that wraps the NotificationSchedulerPlugin addon.
## Add this as an autoload named "NotificationHandler" in Project Settings.

const DEFAULT_CHANNEL_ID := "default_channel"
const DEFAULT_CHANNEL_NAME := "General Notifications"

var _scheduler: NotificationScheduler
var _is_initialized := false
var _next_notification_id := 1
var _is_android := false
var _plugin_available := false  # True only when native plugin is loaded

signal initialized()
signal notification_opened(notification_data: NotificationData)
signal notification_dismissed(notification_data: NotificationData)
signal permission_granted()
signal permission_denied()


func _ready() -> void:
	_is_android = OS.get_name() == "Android"
	
	# Check if the native plugin is available
	if _is_android:
		print("[NotificationHandler] Running on Android")
		if Engine.has_singleton("NotificationSchedulerPlugin"):
			print("[NotificationHandler] Plugin singleton found!")
			_plugin_available = true
		else:
			push_warning("[NotificationHandler] Plugin NOT loaded (debug run?). Notifications will be logged to console.")
			push_warning("  Export an APK for real notifications.")
			_plugin_available = false
	else:
		print("[NotificationHandler] Running on desktop - notifications will be logged to console")
		_plugin_available = false
	
	_scheduler = NotificationScheduler.new()
	add_child(_scheduler)
	
	# Connect signals
	_scheduler.initialization_completed.connect(_on_initialized)
	_scheduler.notification_opened.connect(_on_notification_opened)
	_scheduler.notification_dismissed.connect(_on_notification_dismissed)
	_scheduler.post_notifications_permission_granted.connect(_on_permission_granted)
	_scheduler.post_notifications_permission_denied.connect(_on_permission_denied)
	
	# Initialize the plugin
	_scheduler.initialize()
	
	# Create default channel (required for Android 8+)
	if _plugin_available:
		_create_default_channel()
	else:
		# No plugin - mark as initialized immediately
		_is_initialized = true
		initialized.emit()


func _create_default_channel() -> void:
	var channel := NotificationChannel.new()
	channel.set_id(DEFAULT_CHANNEL_ID) \
		.set_name(DEFAULT_CHANNEL_NAME) \
		.set_description("Default notification channel") \
		.set_importance(NotificationChannel.Importance.HIGH) \
		.set_badge_enabled(true)
	_scheduler.create_notification_channel(channel)


func _on_initialized() -> void:
	_is_initialized = true
	
	# Auto-request notification permission on Android 13+ if not granted
	if _plugin_available and not _scheduler.has_post_notifications_permission():
		# Small delay to let the app fully load before showing permission dialog
		await get_tree().create_timer(0.5).timeout
		_scheduler.request_post_notifications_permission()
	
	initialized.emit()


func _on_notification_opened(data: NotificationData) -> void:
	notification_opened.emit(data)


func _on_notification_dismissed(data: NotificationData) -> void:
	notification_dismissed.emit(data)


func _on_permission_granted(_permission_name: String) -> void:
	permission_granted.emit()


func _on_permission_denied(_permission_name: String) -> void:
	permission_denied.emit()


## Send a notification immediately with just a message.
func Notify(message: String, title: String = "Notification") -> int:
	return schedule_notification(title, message, 0)


## Schedule a notification to appear after a delay (in seconds).
func schedule_notification(title: String, content: String, delay_seconds: int = 0, channel_id: String = DEFAULT_CHANNEL_ID) -> int:
	var notif_id := _get_next_id()
	
	# Fallback - just log to console
	if not _plugin_available:
		if delay_seconds > 0:
			print("[NOTIFICATION scheduled in %ds] %s: %s" % [delay_seconds, title, content])
		else:
			print("[NOTIFICATION] %s: %s" % [title, content])
		return notif_id
	
	var notif := NotificationData.new()
	notif.set_id(notif_id) \
		.set_channel_id(channel_id) \
		.set_title(title) \
		.set_content(content) \
		.set_small_icon_name(NotificationScheduler.DEFAULT_ICON_NAME) \
		.set_delay(delay_seconds * 1000)  # Plugin expects milliseconds, 0 = immediate
	
	var error := _scheduler.schedule(notif)
	if error != OK:
		push_error("Failed to schedule notification: %s" % error)
		return -1
	
	return notif_id


## Schedule a repeating notification at a fixed interval (in seconds).
func schedule_repeating(title: String, content: String, initial_delay_seconds: int, interval_seconds: int, channel_id: String = DEFAULT_CHANNEL_ID) -> int:
	var notif_id := _get_next_id()
	
	# Fallback - just log to console
	if not _plugin_available:
		print("[NOTIFICATION repeating in %ds, every %ds] %s: %s" % [initial_delay_seconds, interval_seconds, title, content])
		return notif_id
	
	var notif := NotificationData.new()
	notif.set_id(notif_id) \
		.set_channel_id(channel_id) \
		.set_title(title) \
		.set_content(content) \
		.set_small_icon_name(NotificationScheduler.DEFAULT_ICON_NAME) \
		.set_delay(initial_delay_seconds * 1000) \
		.set_interval(interval_seconds * 1000)  # Plugin expects milliseconds
	
	var error := _scheduler.schedule(notif)
	if error != OK:
		push_error("Failed to schedule repeating notification: %s" % error)
		return -1
	
	return notif_id


## Cancel a scheduled notification by ID.
func cancel_notification(notification_id: int) -> Error:
	if not _plugin_available:
		print("[NOTIFICATION cancelled] ID: %d" % notification_id)
		return OK
	return _scheduler.cancel(notification_id)


## Create a custom notification channel (required for Android 8+).
func create_channel(id: String, channel_name: String, description: String = "", importance: NotificationChannel.Importance = NotificationChannel.Importance.DEFAULT) -> Error:
	if not _plugin_available:
		return OK
	var channel := NotificationChannel.new()
	channel.set_id(id) \
		.set_name(channel_name) \
		.set_description(description) \
		.set_importance(importance) \
		.set_badge_enabled(true)
	return _scheduler.create_notification_channel(channel)


## Set the app badge count.
func set_badge_count(count: int) -> Error:
	if not _plugin_available:
		return OK
	return _scheduler.set_badge_count(count)


## Check if the app has permission to post notifications.
func has_permission() -> bool:
	if not _plugin_available:
		return true
	return _scheduler.has_post_notifications_permission()


## Request permission to post notifications (required for Android 13+).
func request_permission() -> Error:
	if not _plugin_available:
		return OK
	return _scheduler.request_post_notifications_permission()


## Check if battery optimizations are disabled (for reliable background notifications).
func has_battery_permission() -> bool:
	if not _plugin_available:
		return true
	return _scheduler.has_battery_optimizations_permission()


## Request to disable battery optimizations.
func request_battery_permission() -> Error:
	if not _plugin_available:
		return OK
	return _scheduler.request_battery_optimizations_permission()


## Check if exact alarm permission is granted (for precise scheduling).
func has_exact_alarm_permission() -> bool:
	if not _plugin_available:
		return true
	return _scheduler.has_schedule_exact_alarm_permission()


## Request exact alarm permission.
func request_exact_alarm_permission() -> Error:
	if not _plugin_available:
		return OK
	return _scheduler.request_schedule_exact_alarm_permission()


## Open app info settings (useful if permissions were denied).
func open_settings() -> Error:
	if not _plugin_available:
		return OK
	return _scheduler.open_app_info_settings()


## Returns whether the notification system is initialized and ready.
func is_ready() -> bool:
	return _is_initialized


func _get_next_id() -> int:
	var id := _next_notification_id
	_next_notification_id += 1
	return id
