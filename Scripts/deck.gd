extends Node2D

# call the card_scene
@onready var jump_card_scene: PackedScene = preload("res://Scenes/Cards/JumpCard.tscn")
@onready var speed_card_scene: PackedScene = preload("res://Scenes/Cards/SpeedCard.tscn")

@onready var spawn_point = $CanvasLayer/Spawn
@onready var spawn_point2 = $CanvasLayer/Spawn2


var card_scenes: Array = []
#Random Number Generator
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	card_scenes = [jump_card_scene, speed_card_scene]
	var card_num = rng.randi_range(0,1)
	print(card_num)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	var position = 0;
	for n in 3:
		var card_num = rng.randi_range(0,1)
		var card_scene = card_scenes[card_num]
		var card = card_scene.instantiate()
		spawn_point.add_child(card)
		
		if n != 0 : 
			position += 180
			card.position.x += position	
