@tool
extends Node2D

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var open: bool = false:
	set(value):
		open = value
		set_open(open)
	get:
		return open

@export_enum("North", "East", "South", "West") var direction: int:
	set(value):
		direction = value
		set_open(open)
	get:
		return direction

@export var open_sound: AudioStream = preload("res://assets/sounds/door/open.wav")
@export var close_sound: AudioStream = preload("res://assets/sounds/door/close.wav")

func _ready():
	set_open(open)

func set_open(tog: bool):
	if not animation:
		return
	var open_state = ""
	if tog == true:
		open_state = "open_"
	if direction == 0:
		animation.play(open_state + "north")
	elif direction == 1:
		animation.play(open_state + "east")
	elif direction == 2:
		animation.play(open_state + "south")
	elif direction == 3:
		animation.play(open_state + "west")
	play_state_sound()

func play_state_sound():
	if not audio:
		return
	if open:
		audio.set_stream(open_sound)
	else:
		audio.set_stream(close_sound)
	audio.play()


func _on_interaction_area_interacted(user):
	open = not open
