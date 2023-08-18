extends CharacterBody2D

signal interacted

@export var speed = 125
@export var controllable = false

@onready var animation = $AnimationPlayer

var attack = false
var interact = false

func get_input():
	set_movement(Input.get_vector("left", "right", "up", "down"))
	set_attacking(Input.is_action_just_pressed("attack"))
	set_interacting(Input.is_action_just_pressed("interact"))
	
	if animation.current_animation == "KnifeSwing":
		return
	$DirectionPivot.rotation = snapped(global_position.direction_to(get_global_mouse_position()).angle(), PI/4)
	var dir = int((snapped($DirectionPivot.rotation / PI, 0.01) + 1) * 4) + 2
	$SpriteGroup.set_dir(8 - dir)

func set_movement(input_direction):
	velocity = input_direction * speed

func set_attacking(tog):
	attack = tog

func set_interacting(tog):
	interact = tog

func _physics_process(delta):
	if controllable:
		get_input()
	move_and_slide()

	if attack and not animation.is_playing():
		swing_knife()

	if interact:
		emit_signal("interacted")


func _on_health_component_depleted():
	print("I died :(")
	rotate(PI/2)
	$HitBox/CollisionShape2D.set_deferred("disabled", true)
	$CollisionShape2D.set_deferred("disabled", true)
	controllable = false


func swing_knife():
	animation.play("KnifeSwing")


func _on_swing_area_entered(area):
	var parent = area.get_parent()
	if parent == self:
		return
	var health = parent.get_node_or_null("HealthComponent")
	if area.name == "HitBox" and health:
		health.health -= 15
		var sound = AudioStreamPlayer2D.new()
		sound.stream = preload("res://assets/sounds/knife/stab1.wav")
		sound.max_distance = 700
		sound.connect("finished", sound.queue_free)
		parent.add_child(sound)
		sound.play()


func _on_hit_box_area_entered(area):
	if area.has_method("_on_interact"):
		interacted.connect(area._on_interact.bind(self))


func _on_hit_box_area_exited(area):
	if area.has_method("_on_interact"):
		interacted.disconnect(area._on_interact)
