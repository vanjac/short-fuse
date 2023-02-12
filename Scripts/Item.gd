extends RigidBody3D

signal used

func _pick_up():
	print("picked up")
	gravity_scale = 0
	
func _put_down():
	print("put down")
	gravity_scale = 1

func _use():
	used.emit()
