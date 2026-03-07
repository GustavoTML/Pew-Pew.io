extends Control

@onready var player = get_node("/root/World/Player")
@onready var option_1: Button = %Option1
@onready var option_2: Button = %Option2
@onready var option_3: Button = %Option3
@onready var point_1: Marker2D = $Options_Box/Option1/Point
@onready var point_2: Marker2D = $Options_Box/Option2/Point
@onready var point_3: Marker2D = $Options_Box/Option3/Point
@onready var hand_selector: Control = %Hand_Selector
@onready var hand_seletor_anim: AnimationPlayer = %Hand_seletor_Anim
@onready var entry_anim: AnimationPlayer = %Entry_Anim
@onready var sort_animator: AnimationPlayer = %Sort_Animator

var used_icons:Array = []

var selected_option:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	XP.new_gun.connect(_on_new_gun)
	visible = false
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_option_1_pressed() -> void:
	selected_option = 1
	#player.add_gun(option_1.gun)
	hand_seletor_anim.play("entry")


func _on_option_2_pressed() -> void:
	selected_option = 2
	#player.add_gun(option_2.gun)
	hand_seletor_anim.play("entry")


func _on_option_3_pressed() -> void:
	selected_option = 3
	#player.add_gun(option_3.gun)
	hand_seletor_anim.play("entry")


func reroll(randoms:int = 3):
	match randoms:
		3:
			get_random_icon(option_3, point_3)
		2:
			get_random_icon(option_2, point_2)
		1:
			get_random_icon(option_1, point_1)



func get_random_icon(option:Button, point:Marker2D):
	if used_icons.size() >= 3:
		used_icons.clear()
	
	# Excluindo icon atual para um novo
	if point.get_child_count():
		point.get_child(0).queue_free()
	
	# pegando um arma e icon aleatório
	if XP.level > 1:
		option.gun = Guns.sort()
		option.gun_icon = Guns.all_gun_icon_map[option.gun]
	else:
		option.gun = Guns.sort_pistol()
		option.gun_icon = Guns.all_gun_icon_map[option.gun]
	
	# instanciando / colocando no local certo
	var new_icon = option.gun_icon.instantiate()
	
	# Evita icons repetidos
	for used_icon in used_icons:
		if used_icon == new_icon.get_id():
			return get_random_icon(option, point)
	
	used_icons.push_front(new_icon.get_id()) # guardando para evitar repetição
	option.gun_id = new_icon.get_id()
	# Muito loco esses deferred
	point.call_deferred("add_child", new_icon)
	new_icon.set_deferred("global_position", point.global_position)



func add_new_gun():
	match selected_option:
		1:
			player.add_gun(option_1.gun, hand_selector.hand_selected)
			if hand_selector.hand_selected == 1:
				player.gun_left = option_1.gun_id
			else:
				player.gun_right = option_1.gun_id
			close()
		2:
			player.add_gun(option_2.gun, hand_selector.hand_selected)
			if hand_selector.hand_selected == 1:
				player.gun_left = option_2.gun_id
			else:
				player.gun_right = option_2.gun_id
			close()
		3:
			player.add_gun(option_3.gun, hand_selector.hand_selected)
			if hand_selector.hand_selected == 1:
				player.gun_left = option_3.gun_id
			else:
				player.gun_right = option_3.gun_id
			close()


# INICIANDO O MENU
func _on_new_gun():
	hand_selector.update_all()
	sort_animator.play("Sort")
	entry_anim.play("entry")
	get_tree().paused = true
	visible = true


# FINALIZANDO O MENU
func close():
	hand_seletor_anim.play_backwards("entry")
	entry_anim.play_backwards("entry")
	await entry_anim.animation_finished
	get_tree().paused = false
	visible = false
	XP.level_up_pending = false
	XP.add_xp(0)


# SELECINANDO NEM UMA ARMA
func _on_no_gun_pressed() -> void:
	hand_selector.visible = false
	close()
	hand_selector.visible = false
