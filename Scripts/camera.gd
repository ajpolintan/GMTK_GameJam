extends Camera2D

func _ready():
	limit_top = -440
	limit_bottom = 50


func _on_game_forest() -> void:
	limit_top = -440
	limit_bottom = 50
	
func _on_game_clouds() -> void:
	limit_top = -1560
	limit_bottom = 50

func _on_game_lab() -> void:
	limit_top = -1180
	limit_bottom = -94
