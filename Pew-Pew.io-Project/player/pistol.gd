extends Area2D

const BULLET = preload("res://player/bullet.tscn")
@onready var bullet_point: Marker2D = $Pivot/Pistol/Bullet_Point
@onready var cd_shoot: Timer = $CD_Shoot
@onready var gun: Sprite2D = $Pivot/Pistol
var can_shoot:bool = true
var tps:float = 0.5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	if global_rotation > deg_to_rad(90)  or global_rotation < deg_to_rad(-90):
		gun.scale.y = -0.5
	else:
		gun.scale.y = 0.5
	shoot()

func shoot():
	if can_shoot:
		var new_bullet = BULLET.instantiate()
		bullet_point.add_child(new_bullet)
		new_bullet.global_position = bullet_point.global_position
		new_bullet.global_rotation = bullet_point.global_rotation
		can_shoot = false
		cd_shoot.start(tps)
	

func _on_cd_shoot_timeout() -> void:
	can_shoot = true
	
