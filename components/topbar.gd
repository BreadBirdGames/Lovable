class_name Topbar extends PanelContainer

@export var hp_label: Label

func _ready() -> void:
    Stats.hp_changed.connect(hp_changed)

func hp_changed(hp: int) -> void:
    print(hp)
    hp_label.text = "HP: " + str(hp)