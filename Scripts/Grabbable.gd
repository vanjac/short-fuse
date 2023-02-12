extends Node

signal grabbed

func _grab():
	grabbed.emit()
