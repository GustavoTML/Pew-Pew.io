extends CharacterBody2D

const SHOT = preload("res://enemies/projecties/slime_shot/slime_shot.tscn")
const POPUP = preload("res://effect/popup/damage_popup.tscn")
@onready var animator: AnimationPlayer = %Animator
@onready var lifebar: ProgressBar = %Lifebar
@onready var damage_area: Area2D = $Damage_Area
@onready var jump_attack_cd: Timer = $Jump_Attack_CD
@onready var damage_trail: Sprite2D = %Damage_Trail

@onready var player = get_node("/root/World/Player")
var xp:int = 200
var in_knockback:bool = false
var can_move:bool = false
var speed = 180.0
var direction:Vector2
var life:float = 3000
var damage:float = 40
var player_in:bool = false
var target_player = position


func _ready() -> void:
	life_upd()
	can_move = false
	animator.play("entry")
	await animator.animation_finished
	can_move = true


func _physics_process(delta: float) -> void:
	if can_move and not in_knockback:
		target_player = player.global_position
		direction = global_position.direction_to(player.global_position)
		animator.play("walk")
		velocity = direction.normalized() * speed
	elif life <= 0:
		velocity = Vector2.ZERO
	if global_position.distance_to(target_player) > 20:
		move_and_slide()
	
	if player_in:
		var targets = damage_area.get_overlapping_bodies()
		for target in targets:
			if target.has_method("take_damage"):
				target.take_damage(damage * delta)
			if target.has_method("get_poison"):
				target.get_poison(2.5, 7)


func take_damage(dam:float = 10):
	life -= dam
	%Hit_Anim.play("hit")
	popup(dam)
	lifebar.value = life
	if life <= 0:
		can_move = false
		$Hitbox.queue_free()
		damage_area.queue_free()
		lifebar.visible = false
		Global.boss = 0
		XP.add_xp(xp)
		animator.play("die")


func popup(dam):
	var new_popup = POPUP.instantiate()
	add_sibling(new_popup)
	new_popup.global_position = global_position
	new_popup.popup(dam)


func _on_damage_area_body_entered(body: Node2D) -> void:
	player_in = true
func _on_damage_area_body_exited(body: Node2D) -> void:
	player_in = false


func knockback(source_position:Vector2, force):
	if can_move:
		in_knockback = true
		var knock_dir = source_position.direction_to(global_position)
		velocity = knock_dir * force
		$Knockback_CD.start(0.25)


func _on_knockback_cd_timeout() -> void:
	in_knockback = false


func life_upd(life_value:float = life):
	life = life_value
	lifebar.max_value = life_value
	lifebar.value = life_value


func camerashake(intensity = 10):
	var camera = get_node("/root/World/Player/Camera")
	camera.camerashake(intensity)


func _on_jump_attack_cd_timeout() -> void:
	jump_attack()

# Animation
func jump_attack():
	if life > 0:
		can_move = false
		velocity = Vector2.ZERO
		animator.play("jump_attack")
		await animator.animation_finished
		can_move = true
		multiple_shot()
		jump_attack_cd.start(randf_range(4.5, 5.5))

# Animation
func multiple_shot():
	if life > 0:
		can_move = false
		animator.play("RESET")
		await animator.animation_finished
		animator.play("multiple_shots")
		await animator.animation_finished
		can_move = true


# shot function / 4 or 8 directions
func all_direction_shot():
	# 4 DIREÇÔES
	if life >= 1500:
		for i in range(4):
			var new_shot = SHOT.instantiate()
			add_sibling(new_shot)
			new_shot.global_position = global_position
			new_shot.can_poison = true
			new_shot.poison_timer = 7
			new_shot.damage = 7
			new_shot.global_rotation = deg_to_rad(90 * i)
	
	# 8 DIREÇÔES
	elif life:
		for i in range(8):
			var new_shot = SHOT.instantiate()
			add_sibling(new_shot)
			new_shot.global_position = global_position
			new_shot.can_poison = true
			new_shot.poison_timer = 7
			new_shot.damage = 5
			new_shot.global_rotation = deg_to_rad(45 * i)


# shot function / triple shots
func one_direction_shot():
	# 1 TIRO
	if life > 1000:
		var new_shot = SHOT.instantiate()
		add_sibling(new_shot)
		new_shot.global_position = global_position
		new_shot.can_poison = true
		new_shot.damage = 10
		new_shot.speed = 550
		new_shot.look_at(player.global_position)
	elif life:
		for i in range(3):
			var new_shot = SHOT.instantiate()
			add_sibling(new_shot)
			new_shot.global_position = global_position
			new_shot.can_poison = true
			new_shot.damage = 10
			new_shot.speed = 580
			new_shot.look_at(player.global_position)
			new_shot.global_rotation += deg_to_rad(-20 + (20 * i))


func desactive_all(switch:bool = true):
	$Damage_Area/Damage.set_deferred("disabled", switch)
	$Hitbox.set_deferred("disabled", switch)
	damage_trail.visible = switch


func set_direction(no_move:bool = false):
	if !no_move:
		target_player = player.global_position
		velocity = global_position.direction_to(target_player) * speed * 3
	else:
		velocity = Vector2.ZERO


func idle():
	animator.play("RESET")
	animator.play("idle")
