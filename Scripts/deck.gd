extends Control
# call the card_scene
@onready var jump_card_scene: PackedScene = preload("res://Scenes/Cards/JumpCard.tscn")
@onready var speed_card_scene: PackedScene = preload("res://Scenes/Cards/SpeedCard.tscn")
@onready var time_increase_card_scene: PackedScene = preload("res://Scenes/Cards/TimeIncreaseCard.tscn")
@onready var dash_card_scene: PackedScene = preload("res://Scenes/Cards/DashCard.tscn")
@onready var jump_boost_card_scene: PackedScene = preload("res://Scenes/Cards/JumpBoost.tscn")
@onready var glide_card_scene: PackedScene = preload("res://Scenes/Cards/GlideCard.tscn")


@onready var spawn_point = $CanvasLayer/Spawn
@onready var player = $Player 
@onready var HUD = $"../CanvasLayer/HUD" 
@onready var dash_icon = $"../CanvasLayer/HUD/Dash" 

#gain player scene
@export var Player : PackedScene = preload("res://Scenes/Player.tscn")

signal selected

var card_scenes: Array = []
#Random Number Generator
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	card_scenes = [jump_card_scene, speed_card_scene, time_increase_card_scene, dash_card_scene, jump_boost_card_scene, glide_card_scene]
	var card_num = rng.randi_range(0,card_scenes.size())
	dash_icon.visible = false
	print(card_num)
	hide_buttons()

	pass # Replace with function body.



func _on_cards() -> void:
	await get_tree().create_timer(1).timeout
	print(HUD.time)
	print("Creating cards...")
	$CanvasLayer/HBoxContainer/Option.visible = true
	$CanvasLayer/HBoxContainer/Option2.visible = true
	$CanvasLayer/HBoxContainer/Option3.visible = true

	#Creating Cards...
	var card_position = 0;
	for n in 3:
		var card_num = rng.randi_range(0,card_scenes.size() - 1)
		var card_scene = card_scenes[card_num]
		var card = card_scene.instantiate()
		spawn_point.add_child(card)

		# how do i select a card and make sure that card has the same effect on the player
		
		if n != 0 : 
			card_position += 300
			card.position.x += card_position	
		

func activate_ability(ability_name: String) -> void:
	match ability_name:
		"Jump":
			player.doubleJumpMax += 1
		"Speed":
			player.speedMult += 0.2
		"IncreaseTime":
			HUD.time += 10
		"Dash":
			player.dashUnlock = true
			dash_icon.visible = true
		"JumpBoost":
			print("Increased Jump!")
			player.jumpMult += 0.1
			#remove the dash card
			card_scenes.erase(dash_card_scene)

	emit_signal("selected")

func hide_buttons() -> void:
	$CanvasLayer/HBoxContainer/Option.visible = false
	$CanvasLayer/HBoxContainer/Option2.visible = false
	$CanvasLayer/HBoxContainer/Option3.visible = false
	
func _on_option_pressed() -> void:
	var first_card = spawn_point.get_child(0)
	var first_card_name = first_card.get_node("Card").card_name
	activate_ability(first_card_name)
			
	for card in spawn_point.get_children():
		card.queue_free()
		
	hide_buttons()




func _on_option_2_pressed() -> void:
	var second_card = spawn_point.get_child(1)
	var second_card_name = second_card.get_node("Card").card_name
	
	activate_ability(second_card_name)

			
	for card in spawn_point.get_children():
		card.queue_free()
		
	hide_buttons()



func _on_option_3_pressed() -> void:
	var third_card = spawn_point.get_child(2)
	var third_card_name = third_card.get_node("Card").card_name
	
	activate_ability(third_card_name)

			
	for card in spawn_point.get_children():
		card.queue_free()
		
	hide_buttons()
