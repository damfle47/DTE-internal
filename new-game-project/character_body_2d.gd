extends CharacterBody2D

@export var max_health: float = 100.0
@export var damage_per_second: float = 5.0

var health: float

@onready var health_bar: ProgressBar = $ProgressBar

func _ready():
	health = max_health

	health_bar.max_value = max_health
	health_bar.value = health

func _process(delta):
	# Lose health over time
	health -= damage_per_second * delta
	health = clamp(health, 0, max_health)

	update_health_bar()

	if health <= 0:
		die()

func heal(amount: float):
	health += amount
	health = clamp(health, 0, max_health)

	update_health_bar()

func update_health_bar():
	health_bar.value = health

func die():
	print("Player died")
	queue_free()
