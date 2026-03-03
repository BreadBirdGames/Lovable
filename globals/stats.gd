extends Node

signal food_changed(value: float)
signal water_changed(value: float)
signal sleep_changed(value: float)
signal hp_changed(value: int)

var _food: float
var _water: float
var _sleep: float
var _hp: int

var hp: int:
	get:
		return _hp
	set(value):
		_hp = value
		hp_changed.emit(value)


var food: float:
	get:
		return _food
	set(value):
		_food = value
		calc_health()
		food_changed.emit(value)

var water: float:
	get:
		return _water
	set(value):
		_water = value
		calc_health()
		water_changed.emit(value)

var sleep: float:
	get:
		return _sleep
	set(value):
		_sleep = value
		calc_health()
		sleep_changed.emit(value)

func calc_health() -> void:
	hp = roundi(
		((sleep/100) * 33.33) + 
		((sleep/100) * 33.33) + 
		((sleep/100) * 33.33)
	)