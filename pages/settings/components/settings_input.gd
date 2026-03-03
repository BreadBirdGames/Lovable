class_name SettingsInput extends PanelContainer

@export var title: String
@export var property: String

@export var edit: LineEdit
@export var label: Label

func _ready() -> void:
	label.text = title

	var sig: Signal = SettingsStore.get(property + "_changed")
	assert(sig, "Couldn't find signal " + property + " in Stats")
	sig.connect(update_text)

	edit.text = SettingsStore.get(property)

func update_text(_value: String) -> void:
	if edit.text == _value:
		return

	edit.text = _value

func _on_line_edit_text_changed(new_text: String) -> void:
	SettingsStore.set(property, new_text)
