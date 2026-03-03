class_name Main extends Control

@export var default_page: Page.Type
@export var packed_pages: Dictionary[Page.Type, PackedScene]

@export_group("Internal")
@export var page_container: Control

func _ready() -> void:
	PageManager.set_values(default_page, packed_pages, page_container)
