extends CharacterBody2D

const SLIME = preload("res://enemies/blue_slime/blue_slime.tscn")
const BULLET = preload("res://enemies/projecties/slime_shot/slime_shot.tscn")
const POPUP = preload("res://effect/popup/damage_popup.tscn")

@onready var animator: AnimationPlayer = %Animator
@onready var lifebar: ProgressBar = $Lifebar
@onready var damage_area: Area2D = $Damage_Area
@onready var cd: Timer = %CD
@onready var trail: Marker2D = $Trail

@onready var player:CharacterBody2D = get_node("/root/World/Player")
var speed = 120.0
var direction:Vector2
var life:float = 2500
var damage:float = 25
var player_in:bool = false
var can_move:bool = false
var xp:float = 150
var stage:int = 1
var in_attack:bool = false

func _ready() -> void:
	life_upd()
	animator.play("entry")
	await animator.animation_finished
	can_move = true
	cd.start(3)


func _physics_process(delta: float) -> void:
	if life > 2000:
		stage = 1
	elif life > 1350:
		stage = 2
	elif life > 800:
		stage = 3
	
	if can_move:
		animator.play("walk")
		set_direction()
	elif !in_attack:
		direction = Vector2.ZERO
	velocity = direction.normalized() * speed
	move_and_slide()
	trail.look_at(player.global_position)
	if player_in:
		var targets = damage_area.get_overlapping_bodies()
		for target in targets:
			if target.has_method("take_damage"):
				target.take_damage(damage * delta)


func take_damage(dam:float = 10):
	life -= dam
	popup(dam)
	%Hit_Anim.play("hit")
	lifebar.value = life
	if life <= 0:
		$Hitbox.queue_free()
		XP.add_xp(xp)
		Global.boss = 0
		queue_free()


func popup(dam):
	var new_popup = POPUP.instantiate()
	add_sibling(new_popup)
	new_popup.global_position = global_position
	new_popup.popup(dam)


func _on_damage_area_body_entered(body: Node2D) -> void:
	player_in = true
func _on_damage_area_body_exited(body: Node2D) -> void:
	player_in = false


func life_upd():
	lifebar.max_value = life
	lifebar.value = life


func create_slime():
	var markets = $Points.get_child_count()
	for markt in range(markets):
		var new_slime = SLIME.instantiate()
		get_parent().add_child(new_slime)
		new_slime.global_position = $Points.get_child(markt).global_position
		new_slime.speed += 50
		new_slime.count = 0
		new_slime.xp = 0
		if new_slime.has_method("knockback"):
			new_slime.knockback(global_position, 300)
	shot()
	cd.start(3)


func shot():
	match stage:
		1:
			for i in range(8):
				var new_bullet = BULLET.instantiate()
				add_child(new_bullet)
				new_bullet.global_position = $Shot_Point.global_position
				new_bullet.rotation = $Shot_Point.global_rotation + deg_to_rad(45 * i)
		2:
			for i in range(16):
				var new_bullet = BULLET.instantiate()
				add_child(new_bullet)
				new_bullet.global_position = $Shot_Point.global_position
				new_bullet.rotation = $Shot_Point.global_rotation + deg_to_rad(22.5 * i)
		3:
			for i in range(16):
				var new_bullet = BULLET.instantiate()
				add_child(new_bullet)
				new_bullet.global_position = $Shot_Point.global_position
				new_bullet.rotation = $Shot_Point.global_rotation + deg_to_rad(22.5 * i)


func _on_cd_timeout() -> void:
	quick_attack()


func quick_attack():
	in_attack = true
	can_move = false
	direction = Vector2.ZERO
	speed = 850
	animator.play("RESET")
	await animator.animation_finished
	if stage == 3:
		animator.speed_scale = 0.5
		animator.play("hurt")
		await animator.animation_finished
	animator.play("RESET")
	await animator.animation_finished
	animator.play("quick_attack")
	await animator.animation_finished
	speed = 120
	in_attack = false
	animator.play("hurt")
	await animator.animation_finished
	can_move = true
func set_direction():
	direction = global_position.direction_to(player.global_position)


func camerashake(intensity = 10):
	var camera = get_node("/root/World/Player/Camera")
	camera.camerashake(intensity)
