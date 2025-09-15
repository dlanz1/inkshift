extends CharacterBody2D


const SPEED = 160.0
const JUMP_VELOCITY = -255.0

@onready var sprite = $AnimatedSprite2D

var spawn_position: Vector2

func _ready() -> void:
	# set the initial spawn positionbto where the player is first placed in the level
	spawn_position = global_position

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Sprite direction changing based on direction left/right
	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true

	move_and_slide()

func respawn() -> void:
	print("Player respawning!")
	global_position = spawn_position
	velocity = Vector2.ZERO


func _on_kill_zone_body_entered(body: Node2D) -> void:
	respawn()
