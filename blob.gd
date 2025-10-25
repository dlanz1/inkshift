extends Area2D

const RESPAWN_GROUP := "respawnable_blob"

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var game_manager = %GameManager
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var _spawn_position: Vector2


func _ready() -> void:
	_spawn_position = global_position
	add_to_group(RESPAWN_GROUP)
	_set_active(true)


func _on_body_entered(_body: Node2D) -> void:
	_set_active(false)
	game_manager.add_charge()
	animation_player.play("PickupAnimation")


func respawn() -> void:
	global_position = _spawn_position
	# Drive the AnimationPlayer back to its default state before showing the blob again.
	if animation_player:
		animation_player.call_deferred("play", "RESET")
	call_deferred("_finish_respawn")


func _finish_respawn() -> void:
	_set_active(true)


func _set_active(is_active: bool) -> void:
	if is_active:
		show()
		set_deferred("monitoring", true)
		set_deferred("monitorable", true)
		if collision_shape:
			collision_shape.set_deferred("disabled", false)
		if sprite and not sprite.is_playing():
			sprite.play()
	else:
		hide()
		set_deferred("monitoring", false)
		set_deferred("monitorable", false)
		if collision_shape:
			collision_shape.set_deferred("disabled", true)
		if sprite and sprite.is_playing():
			sprite.stop()
