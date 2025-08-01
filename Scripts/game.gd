extends Node2D
@onready var player: CharacterBody2D = $Deck/Player
@onready var deck: Control = $Deck
@onready var hud: Control = $CanvasLayer/HUD
var curLevel: Node
var level = 1
var spikeWalk = false
signal stop
signal go
signal cards

func _ready():
	stop.connect(Callable(player, "_on_stop"))
	stop.connect(Callable(hud, "_on_stop"))
	go.connect(Callable(player, "_on_go"))
	go.connect(Callable(hud, "_on_go"))
	cards.connect(Callable(deck, "_on_cards"))
	
	load_level("res://Scenes/map1.tscn")


func load_level(path: String):
	if curLevel:
		curLevel.queue_free()
	
	curLevel = load(path).instantiate()
	add_child(curLevel)
	
		# Spawn the player
	var spawnPoint = curLevel.get_node("PlayerSpawn")
	player.global_position = spawnPoint.global_position
	emit_signal("go")

	if curLevel.has_signal("level_finished"):
		curLevel.level_finished.connect(Callable(self, "_on_level_finished"))

func _on_level_finished():
	level += 1
	emit_signal("stop")
	emit_signal("cards")

func _on_deck_selected() -> void:
	var level_amount = 6
	
	match level:
		2:
			load_level("res://Scenes/map2.tscn")
		3:
			load_level("res://Scenes/map3.tscn")
		4:
			load_level("res://Scenes/map4.tscn")
		5:
			load_level("res://Scenes/map5.tscn")
		6:
			load_level("res://Scenes/map6.tscn")
	
			
	if level > level_amount:
		level = 1
		load_level("res://Scenes/map1.tscn")
