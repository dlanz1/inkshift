extends Node

const GROUP_NAME := "game_manager"

var double_jump_charge := 0

@onready var charge_label: Label = $ChargeLabel


func _ready() -> void:
	add_to_group(GROUP_NAME)
	_update_charge_label()


func add_charge() -> void:
	# Increment the collected charge counter and update HUD.
	double_jump_charge += 1
	print(double_jump_charge)
	_update_charge_label()


func reset_charge() -> void:
	# Reset charge count when the player respawns.
	double_jump_charge = 0
	_update_charge_label()


func _update_charge_label() -> void:
	if charge_label:
		charge_label.text = "you collected " + str(double_jump_charge) + " charge"
