extends Button

@onready var option_1: Button = %Option1
@onready var option_2: Button = %Option2
@onready var option_3: Button = %Option3

@onready var point: Marker2D = $Point
var gun_id
var gun
var gun_icon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#get_random_icon()


func _process(delta: float) -> void:
	pass


func fake_reroll():
	if point.get_child_count():
		point.get_child(0).queue_free()
	gun = Guns.all_gun_icon_map.keys().pick_random()
	gun_icon = Guns.all_gun_icon_map[gun]
	var new_icon = gun_icon.instantiate()
	
	point.add_child(new_icon)
	new_icon.global_position = point.global_position
