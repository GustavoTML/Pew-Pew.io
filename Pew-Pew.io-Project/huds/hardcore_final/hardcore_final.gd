extends Control

@onready var animator: AnimationPlayer = $Animator
@onready var informacoes: Control = $Informações

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().call_deferred("reload_current_scene")


func _on_exit_pressed() -> void:
	if OS.has_feature("web"):
		get_tree().paused = false
		JavaScriptBridge.eval("window.location.href = 'saida.html';")
	else:
		get_tree().quit()


func final():
	get_tree().paused = true
	visible = true
	animator.play("entry")
	informacoes.get_informations()


func camerashake(intensity = 10):
	var camera = get_node("/root/World/Player/Camera")
	camera.camerashake(intensity)
