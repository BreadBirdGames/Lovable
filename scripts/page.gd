class_name Page extends Control

enum Type {
	HOME,
	SETTINGS,
	TIPS,
	MENTAL_INDEX,
	HEALTH_INDEX,
	PHYSICAL_INDEX,
}

func set_active(activity: bool) -> void:
	set_process(activity)
	set_process_input(activity)
	visible = activity

func on_open() -> void:
	pass

func on_close() -> void:
	pass