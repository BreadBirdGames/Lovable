extends Node

# Global values
var default_page: Page.Type
var packed_pages: Dictionary[Page.Type, PackedScene]

var page_container: Control

# Internal values
var page_stack: Array[Page]

func get_page(_page_t: Page.Type) -> Page:
	var packed: PackedScene = packed_pages.get(_page_t)
	assert(packed != null, "Invalid page " + str(_page_t))

	var page = packed.instantiate()
	assert(page is Page, "page is not of type page")

	return page

func set_values(_default_page: Page.Type, _packed_pages: Dictionary[Page.Type, PackedScene], _page_container: Control) -> void:
	default_page = _default_page
	packed_pages = _packed_pages
	page_container = _page_container
	goto_page(default_page)

func goto_page(_page_t: Page.Type) -> void:
	var page := get_page(_page_t)
	page_stack.append(page)
	
	if page_stack.size() > 1:
		var prev_page = page_stack[-2]
		prev_page.set_active(false)

	page_container.add_child(page)
	page.set_active(true)

func go_back() -> void:
	if page_stack.size() == 1:
		get_tree().quit()
		return

	var current_page: Page = page_stack.pop_back() as Page
	current_page.queue_free()

	var prev_page = page_stack[-1]
	prev_page.set_active(true)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("back"):
		go_back()

func _notification(what) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		go_back()
