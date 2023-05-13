extends Area2D

signal interacted(user)

func _on_interact(user):
	interacted.emit(user)
