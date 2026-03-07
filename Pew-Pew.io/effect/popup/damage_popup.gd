extends Node2D

@onready var damage: Label = $Damage
@onready var animator: AnimationPlayer = $Animator

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func popup(dam):
	damage.text = str(int(dam))
