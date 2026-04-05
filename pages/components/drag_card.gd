class_name DragCard extends Control

var mouse_pos := Vector2.ZERO
var start_mouse_pos := Vector2.ZERO
var zero_pos := Vector2.ZERO
var is_dragging := false

@export var max_rotation := 0.5

func get_start_state() -> void:
	zero_pos = position

func _ready() -> void:
	call_deferred("get_start_state")

func _process(delta: float) -> void:
	mouse_pos = get_viewport().get_mouse_position()
	
	if is_dragging:
		var tilt_factor = clamp((mouse_pos.x - start_mouse_pos.x) / 200.0, -1.0, 1.0)
		rotation = tilt_factor * max_rotation
		position.x = lerp(position.x, (mouse_pos.x - pivot_offset.x), delta * 8)
	else:
		position.x = lerp(position.x, zero_pos.x, delta * 8)
		rotation = lerp(rotation, 0.0, delta * 8)
	

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				if not is_dragging:  # Starting dragging
					is_dragging = true
					start_mouse_pos = event.global_position
			else:
				if is_dragging: # No longer dragging
					is_dragging = false
					
					start_mouse_pos = Vector2.ZERO
