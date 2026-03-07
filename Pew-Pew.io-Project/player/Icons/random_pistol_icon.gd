extends Area2D


@export var set_rarity:int = 1
var rarity:String
@onready var color: NinePatchRect = $NinePatchRect


func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match set_rarity:
		1:
			color.modulate = Color(0.0, 1.0, 0.0)
			rarity = "commun"
		2:
			color.modulate = Color(1.0, 0.0, 0.0)
			rarity = "raro"
		3:
			color.modulate = Color(0.612, 0.0, 0.847)
			rarity = "epic"
		4:
			color.modulate = Color(0.0, 0.0, 0.0)
			rarity = "legedary"


func _on_body_entered(body: Node2D) -> void:
	XP.new_gun_signal()
	queue_free()
