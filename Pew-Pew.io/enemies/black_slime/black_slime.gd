extends CharacterBody2D

const POPUP = preload("res://effect/popup/damage_popup.tscn")
const SHOT = preload("res://enemies/projecties/slime_shot/slime_shot.tscn")
@onready var animator: AnimationPlayer = %Animator
@onready var lifebar: ProgressBar = $Lifebar
@onready var damage_area: Area2D = $Damage_Area
@onready var shot_cd: Timer = $Shot_CD

@onready var player = get_node("/root/World/Player")
var xp:int = 20
var in_knockback:bool = false
var can_move:bool = false
var speed = 100.0
var direction:Vector2
var life:float = 120
var damage:float = 20
var player_in:bool = false

var count:int = 1
var count2:int = 1

var sort:bool = false
var new_cd:bool = false
var cd_min:float = 5
var cd_max:float = 8

func _ready() -> void:
	life_upd()
	shot_cd.start(cd_min)
	can_move = true


func _physics_process(delta: float) -> void:
	if cd_min != 5 and !new_cd:
		new_cd = true
		shot_cd.start(cd_min)
	if can_move and not in_knockback and life > 0:
		direction = global_position.direction_to(player.global_position)
		animator.play("walk")
		velocity = direction.normalized() * speed
	elif life <= 0 or !can_move:
		velocity = Vector2.ZERO
	move_and_slide()
	
	if player_in:
		var targets = damage_area.get_overlapping_bodies()
		for target in targets:
			if target.has_method("take_damage"):
				target.take_damage(damage * delta)


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
		Global.enemy_defeat += count
		Global.total_enemy_defeat += count2
		XP.add_xp(xp)
		count = 0
		count2 = 0
		animator.play("RESET")
		await animator.animation_finished
		animator.play("die")
		%Hit_Anim.play("die")


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


func shot():
	if life <= 0:
		if sort:
			var degs = randi() % 2
			for i in range(4):
				var new_shot = SHOT.instantiate()
				add_sibling(new_shot)
				new_shot.global_position = global_position
				new_shot.can_poison = true
				new_shot.damage = 5
				new_shot.global_rotation = deg_to_rad(90 * i + degs * 45)
		else:
			for i in range(4):
				var new_shot = SHOT.instantiate()
				add_sibling(new_shot)
				new_shot.global_position = global_position
				new_shot.can_poison = true
				new_shot.damage = 5
				new_shot.global_rotation = deg_to_rad(90 * i)
	else:
		var new_shot = SHOT.instantiate()
		add_sibling(new_shot)
		new_shot.global_position = global_position
		new_shot.can_poison = true
		new_shot.damage = 5
		new_shot.look_at(player.global_position)


func _on_shot_cd_timeout() -> void:
	if life > 0:
		can_move = false
		animator.play("RESET")
		await animator.animation_finished
		animator.play("shot")
		await animator.animation_finished
		if life > 0:
			can_move = true
			shot_cd.start(randf_range(cd_min, cd_max))
