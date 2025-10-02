extends Node2D

@onready var player: Node = $Player


func _ready() -> void:
	if is_instance_valid(player):
		player.respawn_started.connect(_on_player_respawn_started)


func _on_player_respawn_started() -> void:
	_respawn_blobs()


func _respawn_blobs() -> void:
	var blobs := get_tree().get_nodes_in_group("respawnable_blob")
	for blob in blobs:
		if blob.has_method("respawn"):
			blob.respawn()
