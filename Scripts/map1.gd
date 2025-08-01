extends Node2D
@onready var chest: Area2D = $chest

signal level_finished

func _on_chest_chest_get() -> void:
	emit_signal("level_finished")
