extends Area2D

const BULLET = preload("res://player/bullet.tscn")
@onready var bullet_point: Marker2D = $Pivot/Pistol/Bullet_Point
@onready var cd_shoot: Timer = $CD_Shoot
@onready var gun: Sprite2D = $Pivot/Pistol
var can_shoot:bool = true
var tps:float = 0.085


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	if global_rotation > deg_to_rad(90)  or global_rotation < deg_to_rad(-90):
		gun.scale.y = -2.3
	else:
		gun.scale.y = 2.3
	shoot()

func shoot():
	if can_shoot:
		var new_bullet = BULLET.instantiate()
		bullet_point.add_child(new_bullet)
		new_bullet.global_position = bullet_point.global_position
		new_bullet.global_rotation = bullet_point.global_rotation + randf_range(-0.4, 0.4)
		new_bullet.damage = 5
		can_shoot = false
		cd_shoot.start(tps)
	

func _on_cd_shoot_timeout() -> void:
	can_shoot = true
	
