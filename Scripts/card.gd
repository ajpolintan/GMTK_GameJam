class_name Card extends Node2D

signal selectedCard

@export var card_name : String = "Card Name"
@export var card_description : String = "Card Description"
@export var card_image: Sprite2D

@onready var name_label : Label = $CardName/NameLabel
@onready var description_label : Label = $CardDescription
@onready var baseSprite : Sprite2D = $BaseCard
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setCardValues(card_name, card_description)
	
func setCardValues(_name: String, _description: String):
	card_name = _name
	card_description = _description
	
	name_label.set_text(_name)
	description_label.set_text(_description)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta: float) -> void:
	pass

func get_cardName() -> String:
	var message = "hello"
	return message
	
func unhighlight():
	baseSprite.set_modulate(Color(1, 1, 1, 1))
	
func highlight():
	baseSprite.set_modulate(Color(0.5, 1, 1 , 0.8))
		
	
func _on_area_2d_mouse_entered() -> void:
	highlight() # Replace with function body.


func _on_area_2d_mouse_exited() -> void:
	unhighlight()

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	emit_signal("selectedCard")
	print(card_name)
	pass # Replace with function body.
