class_name Home extends Page

func _on_settings_button_pressed() -> void:
	PageManager.goto_page(Page.Type.SETTINGS)

func _on_tips_button_pressed() -> void:
	PageManager.goto_page(Page.Type.TIPS)


func _on_mental_page_pressed() -> void:
	PageManager.goto_page(Page.Type.MENTAL_INDEX)

func _on_health_page_pressed() -> void:
	PageManager.goto_page(Page.Type.HEALTH_INDEX)

func _on_physical_page_pressed() -> void:
	PageManager.goto_page(Page.Type.PHYSICAL_INDEX)
