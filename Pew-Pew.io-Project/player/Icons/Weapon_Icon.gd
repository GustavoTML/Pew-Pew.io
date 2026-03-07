extends Area2D

@export var gun:PackedScene
@export var set_rarity:int = 1
var rarity:String
@onready var color: NinePatchRect = $NinePatchRect
var color_box

var id
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match set_rarity:
		1:
			color_box = Color(0.0, 1.0, 0.0)
			color.modulate = Color(0.0, 1.0, 0.0)
			rarity = "commun"
		2:
			color_box = Color(1.0, 0.0, 0.0)
			color.modulate = Color(1.0, 0.0, 0.0)
			rarity = "raro"
		3:
			color_box = Color(0.612, 0.0, 0.847)
			color.modulate = Color(0.612, 0.0, 0.847)
			rarity = "epic"
		4:
			color_box = Color(0.0, 0.0, 0.0)
			color.modulate = Color(0.0, 0.0, 0.05)
			rarity = "legedary"


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("add_gun"):
		body.add_gun(gun)
		queue_free()

func get_id():
	var new_gun = gun.instantiate()
	id = new_gun.name
	return id
func get_color():
	return color_box
func get_rarity():
	return rarity
