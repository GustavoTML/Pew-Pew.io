extends CharacterBody2D


const POPUP = preload("res://effect/popup/damage_popup.tscn")

@onready var animator: AnimationPlayer = %Animator
@onready var lifebar: ProgressBar = $Lifebar
@onready var damage_area: Area2D = $Damage_Area

@onready var player = get_node("/root/World/Player")
var speed = 220.0
var direction:Vector2
var life:float = 10
var damage:float = 10
var player_in:bool = false
var xp = 4
var can_move:bool = true
var in_knockback:bool = false

var count:int = 1
var count2:int = 1

func _ready() -> void:
	life_upd()


func _physics_process(delta: float) -> void:
	if can_move and not in_knockback:
		direction = global_position.direction_to(player.global_position)
		animator.play("walk")
		velocity = direction.normalized() * speed
	elif life <= 0:
		velocity = Vector2.ZERO
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
		can_move = false
		$Hitbox.queue_free()
		damage_area.queue_free()
		lifebar.visible = false
		Global.enemy_defeat += count
		Global.total_enemy_defeat += count2
		count = 0
		count2 = 0
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


func life_upd(life_value:float = 15):
	life = life_value
	lifebar.max_value = life_value
	lifebar.value = life_value
