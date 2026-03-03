class_name VolumeBar extends PanelContainer

@export var title: String
@export var property: String

@export var slider: Slider
@export var label: Label

func _ready() -> void:
	label.text = title

	var sig: Signal = SettingsStore.get(property + "_changed")
	assert(sig, "Couldn't find signal " + property + " in Stats")
	sig.connect(update_level)

	slider.value = SettingsStore.get(property)

func update_level(_value: float) -> void:
	slider.value = _value

func _on_h_slider_value_changed(value: float) -> void:
	SettingsStore.set(property, slider.value)
