extends CharacterBody2D

@export var max_health := 100
@export var health_drain_per_second := 5.0

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var health : float
var movement_started := false

@onready var health_bar: ProgressBar = $ProgressBar

func _ready():
	health = max_health
	
	health_bar.max_value = max_health
	health_bar.value = health

func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Horizontal movement
	var direction := Input.get_axis("ui_left", "ui_right")

	if direction:
		velocity.x = direction * SPEED
		movement_started = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Drain health after moving
	if movement_started:
		health -= health_drain_per_second * delta
		health = max(health, 0)
		health_bar.value = health

	if health <= 0:
		die()

	move_and_slide()

func die():
	print("Player died!")
	queue_free()
