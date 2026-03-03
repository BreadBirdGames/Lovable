class_name MentalBreathing extends Page

@export var intro_text: String = "Get ready..."
@export var intro_duration: float = 3.0
@export var phases_titles: Array[String]
@export var phases_durations: Array[float]
@export var repeats: int = 1

@export_group("Components")
@export var timer: Timer
@export var instruction_label: Label
@export var repeat_label: Label
@export var time_label: Label
@export var end_button: Button
@export var image: TextureRect

var phase_index: int = 0
var repeat_index: int = 0
var intro_done: bool = false

func start_intro() -> void:
	instruction_label.text = intro_text
	repeat_label.text = "0/" + str(repeats)
	timer.wait_time = intro_duration
	timer.start()

func start_phase() -> void:
	instruction_label.text = phases_titles[phase_index]
	timer.wait_time = phases_durations[phase_index]
	timer.start()

func next_phase() -> void:
	phase_index += 1

	if phase_index >= phases_titles.size():
		phase_index = 0
		repeat_index += 1

		if repeat_index >= repeats:
			end_phases()
			return

		repeat_label.text = str(repeat_index + 1) + "/" + str(repeats)

	start_phase()

func end_phases() -> void:
	end_button.show()
	image.hide()
	timer.stop()

	instruction_label.text = "Finished exercise!"
	time_label.text = ""

func _ready() -> void:
	end_button.hide()
	assert(phases_titles.size() == phases_durations.size(), "phase arrays not equal in length")
	start_intro()

func _process(_delta: float) -> void:
	if timer.is_stopped():
		return

	time_label.text = str(roundi(timer.time_left))

func _on_timer_timeout() -> void:
	if not intro_done:
		intro_done = true
		repeat_label.text = "1/" + str(repeats)
		start_phase()
		return

	next_phase()

func _on_end_button_pressed() -> void:
	PageManager.go_back()
