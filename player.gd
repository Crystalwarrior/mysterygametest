extends CharacterBody2D

@export var speed = 125
@export var controllable = false

@onready var animation = $AnimationPlayer

var attack = false

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	
	attack = Input.is_action_just_pressed("attack")

func _physics_process(delta):
	if controllable:
		get_input()
	move_and_slide()

	if attack and not animation.is_playing():
		swing_knife()


func _on_health_component_depleted():
	print("I died :(")
	rotate(PI/2)
	$HitBox/CollisionShape2D.set_deferred("disabled", true)
	$CollisionShape2D.set_deferred("disabled", true)
	controllable = false


func swing_knife():
	animation.play("KnifeSwing")


func _on_swing_area_entered(area):
	if area.get_parent() == self:
		return
	var health = area.get_parent().get_node_or_null("HealthComponent")
	if area.name == "HitBox" and health:
		health.health -= 15
