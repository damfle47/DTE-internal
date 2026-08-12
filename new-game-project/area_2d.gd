extends Area2D

@export var drop_distance: float = 220.0
@export var drop_time: float = 0.15
@export var stay_down_time: float = 1.0
@export var rise_time: float = 0.3
@export var wait_time: float = 0.5
@export var damage: int = 50

var start_position: Vector2


func _ready() -> void:
	# Remember the original position
	start_position = global_position

	# Connect damage detection
	body_entered.connect(_on_body_entered)

	# Start the trap
	trap_loop()


func _on_body_entered(body) -> void:
	if body.is_in_group("player"):
		body.take_damage(damage)


func trap_loop() -> void:
	while is_inside_tree():

		# =========================
		# DROP DOWN QUICKLY
		# =========================
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_QUAD)
		tween.set_ease(Tween.EASE_IN)

		tween.tween_property(
			self,
			"global_position:y",
			start_position.y + drop_distance,
			drop_time
		)

		await tween.finished


		# =========================
		# STAY DOWN
		# =========================
		await get_tree().create_timer(stay_down_time).timeout


		# =========================
		# GO BACK UP
		# =========================
		tween = create_tween()
		tween.set_trans(Tween.TRANS_QUAD)
		tween.set_ease(Tween.EASE_OUT)

		tween.tween_property(
			self,
			"global_position:y",
			start_position.y,
			rise_time
		)

		await tween.finished


		# =========================
		# WAIT BEFORE DROPPING AGAIN
		# =========================
		await get_tree().create_timer(wait_time).timeout
