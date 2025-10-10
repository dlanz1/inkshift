extends Area2D

@export var expansion_speed: float = 40.0
@export var start_width: float = 32.0
@export var max_width: float = 1800.0
@export var spill_height: float = 720.0
@export var vertical_offset: float = 0.0
@export_node_path("CharacterBody2D") var player_path: NodePath

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var polygon: Polygon2D = $Polygon2D
@onready var player: CharacterBody2D = get_node_or_null(player_path) as CharacterBody2D

var _current_width: float = 0.0

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))
	reset_spill()

func _process(delta: float) -> void:
	if _current_width >= max_width:
		_update_polygon()
		return

	var new_width: float = min(max_width, _current_width + expansion_speed * delta)
	if not is_equal_approx(new_width, _current_width):
		_set_width(new_width)

	_update_polygon()

func reset_spill() -> void:
	_set_width(start_width)
	_update_polygon()

func _set_width(width: float) -> void:
	_current_width = width

	var rect_shape: RectangleShape2D = collision_shape.shape as RectangleShape2D
	if rect_shape == null:
		return

	var clamped_width: float = max(width, 4.0)
	rect_shape.extents = Vector2(clamped_width * 0.5, spill_height * 0.5)
	collision_shape.position = Vector2(clamped_width * 0.5, vertical_offset)

	_update_polygon()

func _on_player_respawn_started() -> void:
	reset_spill()

func _on_body_entered(body: Node) -> void:
	if player and body == player:
		player.respawn()

func _update_polygon() -> void:
	var top: float = -spill_height * 0.5 + vertical_offset
	var bottom: float = spill_height * 0.5 + vertical_offset
	var width: float = max(_current_width, 1.0)

	var vertices: PackedVector2Array = PackedVector2Array([
		Vector2(0.0, top),
		Vector2(width, top),
		Vector2(width, bottom),
		Vector2(0.0, bottom)
	])

	polygon.polygon = vertices
	polygon.uv = PackedVector2Array([
		Vector2(0.0, 0.0),
		Vector2(1.0, 0.0),
		Vector2(1.0, 1.0),
		Vector2(0.0, 1.0)
	])
