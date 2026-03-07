extends Area2D

const BULLET = preload("res://player/bullet.tscn")
@onready var bullet_point: Marker2D = %Bullet_Point
@onready var cd_shoot: Timer = $CD_Shoot
@onready var anim: AnimatedSprite2D = %Anim
var can_shoot:bool = true
var tps:float = 0.1


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
		anim.flip_v = true
	else:
		anim.flip_v = false
	shoot()

func shoot():
	if can_shoot:
		var new_bullet = BULLET.instantiate()
		bullet_point.add_child(new_bullet)
		new_bullet.global_position = bullet_point.global_position
		new_bullet.global_rotation = bullet_point.global_rotation
		new_bullet.is_snipe = true
		new_bullet.scale.x = 0.75
		new_bullet.scale.y = 0.75
		new_bullet.damage = 75
		new_bullet.max_range = 1500
		new_bullet.speed = 1800
		
		can_shoot = false
		anim.play("shot")
		await anim.animation_finished
		anim.play("reload")
		await anim.animation_finished
		cd_shoot.start(tps)
	

func _on_cd_shoot_timeout() -> void:
	can_shoot = true
	
