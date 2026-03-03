class_name Topbar extends PanelContainer

@export var hp_label: Label
@export var name_label: Label

func _ready() -> void:
	Stats.hp_changed.connect(hp_changed)
	SettingsStore.gochi_name_changed.connect(name_changed)

	# Init defaults
	hp_changed(Stats.hp)
	name_changed(SettingsStore.gochi_name)

func hp_changed(hp: int) -> void:
	hp_label.text = "HP: " + str(hp)

func name_changed(new_name: String) -> void:
	name_label.text = "Name: " + new_name
