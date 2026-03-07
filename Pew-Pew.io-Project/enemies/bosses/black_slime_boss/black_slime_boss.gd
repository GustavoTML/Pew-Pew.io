extends CharacterBody2D

const POPUP = preload("res://effect/popup/damage_popup.tscn")
const SHOT = preload("res://enemies/projecties/slime_shot/slime_shot.tscn")
const SLIME = preload("res://enemies/black_slime/black_slime.tscn")
@onready var animator: AnimationPlayer = %Animator
@onready var lifebar: ProgressBar = $Lifebar
@onready var damage_area: Area2D = $Damage_Area
@onready var suction_area: Area2D = $Suction_Area
@onready var suction_particles: CPUParticles2D = %Suction_particles
@onready var skill_cd: Timer = $Skill_Timers/Skill_CD
@onready var points: Node2D = %Points

@onready var player = get_node("/root/World/Player")
var xp:int = 300
var in_knockback:bool = false
var can_move:bool = false
var speed = 100.0
var direction:Vector2
var life:float = 7000
var damage:float = 30
var player_in:bool = false

var degs:float = 0

var sucking = false
var suction_force = 160

var target_player = position

func _ready() -> void:
	life_upd()
	animator.play("entry")
	await animator.animation_finished
	skill_cd.start(1.5)
	can_move = true


func _physics_process(delta: float) -> void:
	# aplicando sucção
	if sucking:
		var bodies = suction_area.get_overlapping_bodies()
		for body in bodies:
			var direction_2 = body.global_position.direction_to(global_position)
			body.global_position += direction_2 * suction_force * delta
	
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


# FUNÇÕES DE TOMAR DANO / DIE
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
		animator.play("RESET")
		await animator.animation_finished
		animator.play("die")
		%Hit_Anim.play("die")
		await animator.animation_finished
func popup(dam):
	var new_popup = POPUP.instantiate()
	add_sibling(new_popup)
	new_popup.global_position = global_position
	new_popup.popup(dam)


# DANO DE CONTATO
func _on_damage_area_body_entered(body: Node2D) -> void:
	player_in = true
func _on_damage_area_body_exited(body: Node2D) -> void:
	player_in = false


func life_upd(life_value:float = life):
	life = life_value
	lifebar.max_value = life_value
	lifebar.value = life_value


func camerashake(intensity = 10):
	var camera = get_node("/root/World/Player/Camera")
	camera.camerashake(intensity)


# ATIRA EM DIREÇÕES ALEATÓRIAS
func random_shots():
	if life > 5000:
		random_direction_bullets(5)
	elif life > 3000:
		random_direction_bullets(7)
	elif life > 1000:
		random_direction_bullets(8)
	else:
		random_direction_bullets(10)
func random_direction_bullets(amount:int):
	for i in range(amount):
			var new_shot = SHOT.instantiate()
			add_sibling(new_shot)
			new_shot.global_position = global_position
			new_shot.can_poison = true
			new_shot.damage = 5
			new_shot.poison_dam = 3.5
			new_shot.speed = randf_range(400, 450)
			new_shot.global_rotation = deg_to_rad(randf_range(0, 360))


# 16 DIREÇÕES
func all_direction_shot():
	if life > 3500:
		degs += 11.25
		if life:
			for i in range(16):
				var new_shot = SHOT.instantiate()
				add_sibling(new_shot)
				new_shot.global_position = global_position
				new_shot.can_poison = true
				new_shot.damage = 8
				new_shot.global_rotation = deg_to_rad(22.5 * i + degs)
	else:
		degs += 5.625
		if life:
			for i in range(32):
				var new_shot = SHOT.instantiate()
				add_sibling(new_shot)
				new_shot.global_position = global_position
				new_shot.can_poison = true
				new_shot.damage = 8
				new_shot.global_rotation = deg_to_rad(11.25 * i + degs)


# SPAWN DE BLACK SLIMES
func create_slime():
	var markets = points.get_child_count()
	for markt in range(markets):
		var new_slime = SLIME.instantiate()
		get_parent().add_child(new_slime)
		new_slime.global_position = points.get_child(markt).global_position
		new_slime.count = 0
		new_slime.sort = true
		new_slime.speed += 100
		new_slime.life += 100
		new_slime.cd_max = 3
		new_slime.cd_min = 1.5
		new_slime.xp = 0
		if new_slime.has_method("knockback"):
			new_slime.knockback(global_position, 300)


# INVULNERABILIDADE / INTANGIBILIDADE
func desactive_all(switch:bool = true):
	$Damage_Area/Damage.set_deferred("disabled", switch)
	$Hitbox.set_deferred("disabled", switch)
	lifebar.visible = !switch


# SUCTION ACTIVATE / DESACTIVATE
func start_suction():
	sucking = true
	suction_particles.emitting = true
func stop_suction():
	sucking = false
	suction_particles.emitting = false


# TIMER DA SKILL PRINCIPAL
func _on_skill_cd_timeout() -> void:
	if life > 0:
		can_move = false
		animator.play("space_skill")
		await  animator.animation_finished
		if life > 0:
			animator.play("entry")
			await animator.animation_finished
		if life > 0:
			animator.play("idle")
			skill_cd.start(2)


# SETANDO DIREÇÃO PARA O PLAYER
func set_direction(no_move:bool = false):
	if !no_move:
		target_player = player.global_position
		velocity = global_position.direction_to(target_player) * speed * 3
	else:
		target_player = position
		velocity = Vector2.ZERO


func _on_knockback_area_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(5)
	if body.has_method("knockback"):
		body.knockback(global_position, 700)


func boss_defeat():
	Global.boss_defeat()
