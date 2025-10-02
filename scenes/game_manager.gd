extends Node

var double_jump_charge = 0

@onready var charge_label = $ChargeLabel

func add_charge():
	double_jump_charge += 1
	print(double_jump_charge)
	
	charge_label.text = "you collected " + str(double_jump_charge) + " charge"
