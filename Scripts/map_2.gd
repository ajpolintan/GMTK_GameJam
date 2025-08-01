extends Node2D
@onready var chest: Area2D = $chest

func _ready():
	$chest.chestGet.connect(Callable(self, "_on_chest_chest_get"))

signal level_finished

func _on_chest_chest_get() -> void:
	emit_signal("level_finished")
