class_name Card extends Node2D

@export var card_name : String = "Card Name"
@export var card_description : String = "Card Description"
@export var card_image: Sprite2D

@onready var name_label : Label = $CardName/NameLabel
@onready var description_label : Label = $CardDescription

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


func _on_area_2d_mouse_entered() -> void:
	pass # Replace with function body.
