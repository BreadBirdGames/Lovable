class_name Main extends Control

@export var default_page: Page.Type

@export var setup_page: Page.Type = Page.Type.SETUP
@export var packed_pages: Dictionary[Page.Type, PackedScene]

@export_group("Internal")
@export var page_container: Control

func _ready() -> void:
	PageManager.set_values(default_page, packed_pages, page_container)
	#if FileAccess.file_exists(Setup.SETUP_FILE_PATH):
	PageManager.goto_page(default_page)
	#else:
	#	PageManager.goto_page(setup_page)
