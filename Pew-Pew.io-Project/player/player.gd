extends CharacterBody2D

@onready var anim: AnimatedSprite2D = %Anim
@onready var lifebar: ProgressBar = %Lifebar
@onready var hand_1: Node2D = %Hand_1
@onready var hand_2: Node2D = %Hand_2
@onready var gameover: Control = %Gameover
@onready var camera: Camera2D = $Camera
@onready var knockback_cd: Timer = $Knockback_CD

var gun_left
var gun_right

var is_life:bool = true

# BASICS PLAYER SETTINGS
var speed = 200.0
var life:float = 25
var direction:Vector2
# Habilities
var have_sniper:bool = false
# States
var poisoned:bool = false
var poison_dam: float = 0
var poison_time:float = 0

var in_knockback:bool = false


func _ready() -> void:
	# LIFE BAR
	lifebar.max_value = life
	lifebar.value = life


func _physics_process(delta: float) -> void:
	# poison
	if poisoned and poison_time:
		lifebar.modulate = Color(0.882, 0.0, 0.702)
		Global.total_damage_take += poison_dam * delta
		life -= poison_dam * delta
		poison_time -= 1 * delta
		if poison_time <= 0:
			poisoned = false
			poison_time = 0
	else:
		lifebar.modulate = Color(0.0, 1.0, 0.0)
	# basic regen
	if life < 25:
		life += 1 * delta
		lifebar.value = life
	# ZOOM DA SNIPER
	if hand_1.has_node("Snipe")  or hand_1.has_node("Sniper_Green") or hand_1.has_node("Golden_Sniper"):
		have_sniper = true
	elif hand_2.has_node("Snipe")  or hand_2.has_node("Sniper_Green") or hand_2.has_node("Golden_Sniper"):
		have_sniper = true
	else:
		have_sniper = false
	if have_sniper:
		if has_node("Camera"):
			$Camera.zoom_in()
	elif has_node("Camera"):
		$Camera.zoom_out()
	
	# MOVIMENTs
	direction = Vector2(0, 0)
	if Input.is_action_pressed("LEFT"):
		direction.x = -1
	if Input.is_action_pressed("RIGHT"):
		direction.x = 1
	if Input.is_action_pressed("UP"):
		direction.y = -1
	if Input.is_action_pressed("DOWN"):
		direction.y = 1
	
	# ANIMATIONS / IMPROVIMENTS
	if velocity.length() > 0 :
		anim.play("run")
	else:
		anim.play("idle")
	if direction.x > 0:
		anim.scale.x = 0.1
	if direction.x < 0:
		anim.scale.x = -0.1
	
	if !in_knockback:
		velocity = direction.normalized() * speed
	move_and_slide()


func take_damage(dam:float = 0.2):
	Global.total_damage_take += dam
	life -= dam
	lifebar.value = life
	if life <= 0 and is_life:
		is_life = false
		Global.death += 1
		gameover.die()


func add_gun(gun_name:PackedScene, hand:int = 0):
	var new_gun = gun_name.instantiate()
	
	if hand == 0:
		if !hand_1.get_child_count():
			hand_1.call_deferred("add_child", new_gun)
		elif !hand_2.get_child_count():
			hand_2.call_deferred("add_child", new_gun)
	elif hand == 1:
		if hand_1.get_child_count():
			hand_1.get_child(0).queue_free()
			hand_1.call_deferred("add_child", new_gun)
		else:
			if !hand_1.get_child_count():
				hand_1.call_deferred("add_child", new_gun)
	elif hand == 2:
		if hand_2.get_child_count():
			hand_2.get_child(0).queue_free()
			hand_2.call_deferred("add_child", new_gun)
		else:
			if !hand_2.get_child_count():
				hand_2.call_deferred("add_child", new_gun)


func get_poison(dam:float = 1, poison_t:float = 5):
	poisoned = true
	poison_dam = dam
	poison_time = poison_t


func knockback(source_position:Vector2, force):
	in_knockback = true
	var knock_dir = source_position.direction_to(global_position)
	velocity = knock_dir * force
	$Knockback_CD.start(0.25)
func _on_knockback_cd_timeout() -> void:
	in_knockback = false
