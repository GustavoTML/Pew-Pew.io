extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(Guns.all_gun_icon_map.keys().map(get_id_guns))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func get_id_guns(gun:PackedScene):
	var icon = Guns.all_gun_icon_map[gun].instantiate()
	
	return icon.get_id()
