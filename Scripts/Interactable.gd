extends Node

signal interacted

func _interact():
	interacted.emit()
