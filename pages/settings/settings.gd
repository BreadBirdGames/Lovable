class_name Settings extends Page

func _on_save_button_pressed() -> void:
	SettingsStore.save()

func _on_restorebutton_pressed() -> void:
	SettingsStore.load_default_values()
	SettingsStore.save()

func _on_check_box_toggled(toggled_on: bool) -> void:
	SettingsStore.notifications = toggled_on
