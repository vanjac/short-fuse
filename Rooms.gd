extends Container

var room_rect = preload("RoomRect.tscn")

func _ready():
	var min_bound = null
	var max_bound = null
	for room in get_tree().get_nodes_in_group("rooms"):
		var coords = get_min_max(room)
		if min_bound == null:
			min_bound = coords[0]
			max_bound = coords[1]
		else:
			for axis in 3:
				if coords[0][axis] < min_bound[axis]:
					min_bound[axis] = coords[0][axis]
				if coords[1][axis] > max_bound[axis]:
					max_bound[axis] = coords[1][axis]

	for hall in get_tree().get_nodes_in_group("hallways"):
		add_room_box(hall, min_bound, max_bound)
	for room in get_tree().get_nodes_in_group("rooms"):
		add_room_box(room, min_bound, max_bound)

func get_min_max(room):
	var coord1 = room.to_global(Vector3.ONE * -.5)
	var coord2 = room.to_global(Vector3.ONE * .5)
	var min = coord1
	var max = coord1
	for axis in 3:
		if coord2[axis] < min[axis]:
			min[axis] = coord2[axis]
		if coord2[axis] > max[axis]:
			max[axis] = coord2[axis]
	return [min, max]

func add_room_box(room, min_bound, max_bound):
	var bounds_size = max_bound - min_bound
	var map_scale = 512 / max(bounds_size.x, bounds_size.z)

	var coords = get_min_max(room)
	var min_coord = coords[0]
	var max_coord = coords[1]
	var rect = room_rect.instantiate()
	add_child(rect)
	var pos = (min_coord - min_bound) * map_scale
	var size = (max_coord - min_coord) * map_scale
	rect.position = Vector2(pos.x, pos.z)
	rect.size = Vector2(size.x, size.z) / rect.scale
