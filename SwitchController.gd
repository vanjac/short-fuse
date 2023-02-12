extends Node3D

@onready var light1 = $/root/Scene/Ship/Lights/OmniLight3D9

func _on_switch_1_switch_on():
	light1.visible = false

func _on_switch_1_switch_off():
	light1.visible = true
