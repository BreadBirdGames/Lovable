extends Node

const SAVE_PATH := "user://save.tres"

signal master_vol_changed(value: float)
signal sfx_vol_changed(value: float)
signal voice_vol_changed(value: float)
signal music_vol_changed(value: float)
signal notifications_changed(value: bool)

var save_game: Save

func _ready() -> void:
	load_save()

func save() -> void:
	ResourceSaver.save(save_game, SAVE_PATH)

func load_save() -> void:
	if not ResourceLoader.exists(SAVE_PATH):
		load_default_values()
		return

	save_game = ResourceLoader.load(SAVE_PATH) as Save
	update_volumes()

func load_default_values() -> void:
	save_game = Save.new()
	master_vol = 100
	sfx_vol = 100
	music_vol = 100
	voice_vol = 100
	notifications = true


func update_volumes() -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(master_vol / 100.0))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(sfx_vol / 100.0))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Voice acting"), linear_to_db(voice_vol / 100.0))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(music_vol / 100.0))


# Below we emit signals and such with changes
var master_vol: float:
	get:
		return save_game.master_vol
	set(value):
		if save_game.master_vol == value:
			return

		save_game.master_vol = value
		update_volumes()
		master_vol_changed.emit(value)

var sfx_vol: float:
	get:
		return save_game.sfx_vol
	set(value):
		if save_game.sfx_vol == value:
			return

		save_game.sfx_vol = value
		update_volumes()
		sfx_vol_changed.emit(value)

var music_vol: float:
	get:
		return save_game.music_vol
	set(value):
		if save_game.music_vol == value:
			return

		save_game.music_vol = value
		update_volumes()
		music_vol_changed.emit(value)

var voice_vol: float:
	get:
		return save_game.voice_vol
	set(value):
		if save_game.voice_vol == value:
			return

		save_game.voice_vol = value
		update_volumes()
		voice_vol_changed.emit(value)

var notifications: bool:
	get:
		return save_game.notifications
	set(value):
		if save_game.notifications == value:
			return
		
		save_game.notifications = value
		notifications_changed.emit(value)
