extends Control

@onready var credits_entry: AnimationPlayer = $Credits_entry

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_credits_pressed() -> void:
	show()
	credits_entry.play("entry")


func _on_button_pressed() -> void:
	credits_entry.play_backwards("entry")
	await credits_entry.animation_finished
	hide()
