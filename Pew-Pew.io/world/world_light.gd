extends CanvasModulate

@onready var animator: AnimationPlayer = $Animator
var shadow:bool = false
var blackout:bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.Hardcore_Mode and !shadow:
		shadow = true
		visible = true
		animator.play("light")
	if Global.wave >= 6 and Global.boss == 1 and !blackout:
		blackout = true
		animator.play("blackout")
