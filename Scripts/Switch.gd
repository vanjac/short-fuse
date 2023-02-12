extends Node3D

signal switch_on
signal switch_off

var on = false

func _on_static_body_3d_used():
	on = not on
	if on:
		switch_on.emit()
		$AnimationPlayer.play("switch_on")
	else:
		switch_off.emit()
		$AnimationPlayer.play_backwards("switch_on")
