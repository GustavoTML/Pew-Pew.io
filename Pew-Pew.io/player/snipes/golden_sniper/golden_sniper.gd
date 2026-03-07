extends Area2D

const BULLET = preload("res://player/bullet.tscn")
const LIGHT_BULLET = preload("res://player/bullets/light_bullet.tscn")
@onready var bullet_point: Marker2D = $Pivot/Pistol/Bullet_Point
@onready var cd_shoot: Timer = $CD_Shoot
@onready var gun: Sprite2D = $Pivot/Pistol
@onready var shot_sound: AudioStreamPlayer2D = %Shot_Sound
var can_shoot:bool = true
var tps:float = 0.75


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	if global_rotation > deg_to_rad(90)  or global_rotation < deg_to_rad(-90):
		gun.scale.y = -2.5
	else:
		gun.scale.y = 2.5
	shoot()


func shoot():
	if can_shoot:
		var new_bullet = LIGHT_BULLET.instantiate()
		bullet_point.add_child(new_bullet)
		new_bullet.global_position = bullet_point.global_position
		new_bullet.global_rotation = bullet_point.global_rotation
		can_shoot = false
		cd_shoot.start(tps)


func _on_cd_shoot_timeout() -> void:
	can_shoot = true
