class_name StatBar extends PanelContainer

@export var icon: Texture2D
@export var property: String

@export var progress: ProgressBar
@export var texture: TextureRect

func _ready() -> void:
	texture.texture = icon
	
	var sig: Signal = Stats.get(property + "_changed")
	assert(sig, "Couldn't find signal " + property + " in Stats")
	sig.connect(update_level)
	update_level(Stats.get(property))

func update_level(_value: float) -> void:
	progress.value = _value
