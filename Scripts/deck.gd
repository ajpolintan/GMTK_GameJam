extends Node2D

# call the card_scene
@onready var jump_card_scene: PackedScene = preload("res://Scenes/Cards/JumpCard.tscn")

@onready var spawn_point = $CanvasLayer/Spawn
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	var jumpCard = jump_card_scene.instantiate()
	spawn_point.add_child(jumpCard)
