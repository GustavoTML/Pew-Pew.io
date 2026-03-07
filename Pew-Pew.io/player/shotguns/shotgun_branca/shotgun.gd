extends Area2D

const BULLET = preload("res://player/bullet.tscn")
@onready var bullet_point: Marker2D = $Pivot/Pistol/Bullet_Point
@onready var cd_shoot: Timer = $CD_Shoot
@onready var gun: Sprite2D = %Pistol
var can_shoot:bool = true
# tps = 1.5 bom
var tps:float = 1


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
		gun.scale.y = -0.05
	else:
		gun.scale.y = 0.05
	shoot()

func shoot():
	if can_shoot:
		for i in range(7):
			var new_bullet = BULLET.instantiate()
			bullet_point.add_child(new_bullet)
			new_bullet.global_position = bullet_point.global_position
			new_bullet.global_rotation = bullet_point.global_rotation + randf_range(0.35, -0.35)
			new_bullet.is_shotgun = true
			new_bullet.damage = 7
			new_bullet.max_range = randi_range(575, 675)
			new_bullet.speed = randi_range(600, 800)
			
		can_shoot = false
		cd_shoot.start(tps)
	

func _on_cd_shoot_timeout() -> void:
	can_shoot = true
	
