extends Button

@onready var player = get_node("/root/World/Player")
@onready var scale_up_right: AnimationPlayer = $Scale_up_right
@onready var point: Marker2D = $Point


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mouse_entered() -> void:
	scale_up_right.play("scale_up")


func _on_mouse_exited() -> void:
	scale_up_right.play_backwards("scale_up")


func update():
	if point.get_child_count() > 0:
		point.get_child(0).queue_free()
	if player.gun_right:
		var gun:PackedScene = Guns.all_icon_names_map[player.gun_right]
		var gun_icon = gun.instantiate()
		point.call_deferred("add_child", gun_icon)
