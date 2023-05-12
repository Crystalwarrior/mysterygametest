extends Node

signal depleted

@export var health = 100:
	set (value):
		health = value
		if health <= 0:
			depleted.emit()
	get:
		return health

@export var max_health = 100:
	set (value):
		max_health = value
		if health > max_health:
			health = max_health
	get:
		return health

func add_health(value):
	health += value
