class_name Settings extends Page

func _on_save_button_pressed() -> void:
	SettingsStore.save()
