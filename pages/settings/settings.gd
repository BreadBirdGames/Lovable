class_name Settings extends Page

@export var notif_control: Control
@export var notif_time_label: Label
@export var notif_timer: Timer

const NOTIFICATIONS: Array[String] = [
	"Have you remembered to breathe today?",
	"Have you drank water?",
	"Remember to look away from the screen!",
	"Remember to stretch.",
]

var random: RandomNumberGenerator

func _ready() -> void:
	random = RandomNumberGenerator.new()
	random.randomize()

	if SettingsStore.notifications:
		notif_control.show()
	else:
		notif_control.hide()

func _on_save_button_pressed() -> void:
	SettingsStore.save()

func _on_restorebutton_pressed() -> void:
	SettingsStore.load_default_values()
	SettingsStore.save()

func _on_notification_check_toggled(toggled_on: bool) -> void:
	SettingsStore.notifications = toggled_on

	if toggled_on:
		notif_control.show()
	else:
		notif_control.hide()

func send_random_notification() -> void:
	if not SettingsStore.notifications:
		return

	print(NOTIFICATIONS[randi_range(0, NOTIFICATIONS.size() - 1)])

	NotificationHandler.Notify(
		NOTIFICATIONS[randi_range(0, NOTIFICATIONS.size() - 1)]
	)

func _on_send_notif_button_pressed() -> void:
	send_random_notification()

func _on_notif_time_slide_value_changed(value: float) -> void:
	notif_time_label.text = str(value) + "s"
	notif_timer.wait_time = value

	if not notif_timer.is_stopped():
		notif_timer.stop()
		notif_timer.start()

func _on_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		if notif_timer.is_stopped():
			notif_timer.start()
	else:
		notif_timer.stop()

func _on_notif_timer_timeout() -> void:
	send_random_notification()
