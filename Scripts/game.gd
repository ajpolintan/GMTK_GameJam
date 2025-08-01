extends Node2D
@onready var player: CharacterBody2D = $Player
var curLevel: Node
var level = 1
signal stop

func _ready():
	stop.connect(Callable(player, "_on_stop"))
	load_level("res://Scenes/map1.tscn")

func load_level(path: String):
	if curLevel:
		curLevel.queue_free()
	
	curLevel = load(path).instantiate()
	add_child(curLevel)
	
		# Spawn the player
	var spawn_point = curLevel.get_node("PlayerSpawn")
	player.global_position = spawn_point.global_position
	emit_signal("stop")

	if curLevel.has_signal("level_finished"):
		curLevel.level_finished.connect(Callable(self, "_on_level_finished"))

func _on_level_finished():
	level += 1
	if level == 2:
		load_level("res://Scenes/map2.tscn")
	if level > 2:
		level = 1
		load_level("res://Scenes/map1.tscn")
