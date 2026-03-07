extends CharacterBody2D

const SLIME = preload("res://enemies/slime/slime.tscn")
const POPUP = preload("res://effect/popup/damage_popup.tscn")


@onready var animator: AnimationPlayer = %Animator
@onready var lifebar: ProgressBar = $Lifebar
@onready var damage_area: Area2D = $Damage_Area
@onready var cd: Timer = %CD

@onready var player = get_node("/root/World/Player")
var speed = 120.0
var direction:Vector2
var life:float = 750
var damage:float = 15
var player_in:bool = false
var can_move:bool = false
var xp:float = 60

func _ready() -> void:
	life_upd()
	
	animator.play("entry")
	await animator.animation_finished
	can_move = true
	cd.start(3)


func _physics_process(delta: float) -> void:
	
	if can_move:
		animator.play("walk")
		direction = global_position.direction_to(player.global_position)
	else:
		direction = Vector2.ZERO
	velocity = direction.normalized() * speed
		
	move_and_slide()
	
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
		new_slime.knockback(global_position, 300)
	cd.start(2)


func _on_cd_timeout() -> void:
	can_move = false
	animator.play("RESET")
	await animator.animation_finished
	animator.play("hurt")
	await animator.animation_finished
	can_move = true


func camerashake(intensity = 10):
	var camera = get_node("/root/World/Player/Camera")
	camera.camerashake(intensity)
