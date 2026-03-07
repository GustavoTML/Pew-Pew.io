extends Control

@onready var exit_anim: AnimationPlayer = $Exit_Anim

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	exit_anim.play("exit")
	await exit_anim.animation_finished
	get_tree().call_deferred("change_scene_to_file", "res://world/world.tscn")


func _on_exit_pressed() -> void:
	if OS.has_feature("web"):
		get_tree().paused = false
		JavaScriptBridge.eval("window.location.href = 'saida.html';")
	else:
		get_tree().quit()
