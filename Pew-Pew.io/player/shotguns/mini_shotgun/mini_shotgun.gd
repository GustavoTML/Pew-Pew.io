extends Area2D

const BULLET = preload("res://player/bullet.tscn")
@onready var bullet_point: Marker2D = $Pivot/Pistol/Bullet_Point
@onready var cd_shoot: Timer = $CD_Shoot
@onready var gun: Sprite2D = %Pistol
@onready var shot_sound: AudioStreamPlayer2D = %Shot_Sound
var can_shoot:bool = true
# tps = 1.5 bom
var tps:float = 0.6


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var enemy = get_overlapping_bodies()
	look_at(get_global_mouse_position())
	#if enemy.size() > 0:
		#look_at(enemy.front().global_position)
	if global_rotation > deg_to_rad(90)  or global_rotation < deg_to_rad(-90):
		gun.scale.y = -1.3
	else:
		gun.scale.y = 1.3
	shoot()

func shoot():
	if can_shoot:
		#shot_sound.play()
		for i in range(14):
			var new_bullet = BULLET.instantiate()
			bullet_point.add_child(new_bullet)
			new_bullet.global_position = bullet_point.global_position
			new_bullet.global_rotation = bullet_point.global_rotation + randf_range(0.6, -0.6)
			new_bullet.is_shotgun = true
			new_bullet.damage = 10
			new_bullet.max_range = randi_range(350, 450)
			new_bullet.speed = randi_range(550, 750)
			
		can_shoot = false
		cd_shoot.start(tps)
	

func _on_cd_shoot_timeout() -> void:
	can_shoot = true
	
