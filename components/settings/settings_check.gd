extends CheckBox

@export var property: String

func _ready() -> void:
	var sig: Signal = SettingsStore.get(property + "_changed")
	assert(sig, "Couldn't find signal " + property + " in Stats")
	sig.connect(update_toggle)

	button_pressed = SettingsStore.get(property)

func update_toggle(_value: bool) -> void:
	button_pressed = _value

func _on_toggled(toggled_on: bool) -> void:
	SettingsStore.set(property, toggled_on)
