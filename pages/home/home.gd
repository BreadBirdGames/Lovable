class_name Home extends Page

@export var mark_tween_time: float = 0.25
@export var left_mark: Control
@export var right_mark: Control
@export var counter: Label

var count: int = 0
var left_mark_tween: Tween
var right_mark_tween: Tween

func _ready() -> void:
	left_mark.hide()
	right_mark.hide()
	
	left_mark.modulate = Color.TRANSPARENT
	right_mark.modulate = Color.TRANSPARENT

#func _on_settings_button_pressed() -> void:
#	PageManager.goto_page(Page.Type.SETTINGS)

func _on_drag_card_dropped_on_left() -> void:
	print("On left!")
	count -= 1
	counter.text = "SCORE: " + str(count)

func _on_drag_card_dropped_on_right() -> void:
	print("On right!")
	count += 1
	counter.text = "SCORE: " + str(count)

func _on_drag_card_drag_switch(state: bool) -> void:
	print(state)
	if left_mark_tween:
		left_mark_tween.kill()
	left_mark_tween = get_tree().create_tween().bind_node(left_mark)
	
	if right_mark_tween:
		right_mark_tween.kill()
	right_mark_tween = get_tree().create_tween().bind_node(right_mark)
	
	if state: # We're hovering
		left_mark.show()
		right_mark.show()
	
		left_mark_tween.tween_property(left_mark, "modulate", Color.WHITE, mark_tween_time)
		right_mark_tween.tween_property(right_mark, "modulate", Color.WHITE, mark_tween_time)
	else:
		left_mark_tween.tween_property(left_mark, "modulate", Color.TRANSPARENT, mark_tween_time)
		right_mark_tween.tween_property(right_mark, "modulate", Color.TRANSPARENT, mark_tween_time)
		
		left_mark_tween.tween_callback(left_mark.hide)
		right_mark_tween.tween_callback(right_mark.hide)
