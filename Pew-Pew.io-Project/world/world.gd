extends Node2D

const SLIME = preload("res://enemies/slime/slime.tscn")
const GREEN_SLIME_BOSS = preload("res://enemies/bosses/green_slime_boss/green_slime_boss.tscn")
const RED_SLIME = preload("res://enemies/red_slime/red_slime.tscn")
const RED_SLIME_BOSS = preload("res://enemies/bosses/red_slime_boss/red_slime_boss.tscn")
const BLUE_SLIME = preload("res://enemies/blue_slime/blue_slime.tscn")
const BLUE_SLIME_BOSS = preload("res://enemies/bosses/blue_slime_boss/blue_slime_boss.tscn")
const PURPLE_SLIME = preload("res://enemies/purple_slime/purple_slime.tscn")
const PURPLE_SLIME_BOSS = preload("res://enemies/purple_slime_boss/purple_slime_boss.tscn")
const BLACK_SLIME = preload("res://enemies/black_slime/black_slime.tscn")
const BLACK_SLIME_BOSS = preload("res://enemies/bosses/black_slime_boss/black_slime_boss.tscn")
@onready var final: Control = $Fim/Final
@onready var hardcore_final: Control = %Hardcore_Final
@onready var spawn_pos: PathFollow2D = %Spawn_Pos
@onready var spawn_slime: Timer = %Spawn_Slime
@onready var spawn_elite_slime: Timer = %Spawn_Elite_Slime
@export var play:bool = true
@onready var world_light: CanvasModulate = $World_Light

var min_spawn:int = 2
var max_spawn:int = 5

func _ready() -> void:
	Global.Final_Boss_Defeat.connect(_final_boss_defeat)
	Global.reset()
	Global.wave1()
	spawn_slime.start(1)
	XP.reset_level()


func _process(delta: float) -> void:
	pass


func create_slime():
	#SPAWN DE ENEMIES
	if Global.enemy_left > 0 and Global.boss == 0:
		# GREEN SLIMES WAVE
		if Global.wave == 1:
			min_spawn = 2
			max_spawn = 6
			green_slime()
		
		# RED SLIMES WAVE
		if Global.wave == 2:
			min_spawn = 5
			max_spawn = 10
			var sort:int = randi()  % 4
			if sort == 2:
				green_slime(20)
			else:
				red_slime()
		
		# BLUE SLIMES WAVE
		if Global.wave == 3:
			min_spawn = 8
			max_spawn = 15
			var sort:int = randi() % 8
			if sort == 0:
				green_slime(25)
			elif sort == 1 or sort == 2:
				red_slime(45)
			else:
				blue_slime()
	
	# BOSSES e TROCA DE WAVE
	elif Global.enemy_left == 0 and Global.enemy_defeat >= Global.enemy_total and Global.boss == 0:
		# GREEN SLIMES BOSS
		if Global.wave == 1:
			green_slime_boss()
		
		# RED SLIMES BOSS
		elif Global.wave == 2:
			red_slime_boss()
		
		# BLUE SLIMES BOSS
		elif Global.wave == 3:
			blue_slime_boss()
		
		# TROCA DE WAVE
		if Global.wave < 3:
			Global.switch_wave(Global.wave)
		
		# HARDCORE START / WAVE 4
		else:
			Global.wave = 4


func _on_spawn_slime_timeout() -> void:
	# IF APENAS PARA TESTAR
	if play:
		# RANDON SPAWN AMAUNT
		var sort:int = randi_range(min_spawn, max_spawn)
		for i in range(sort):
			create_slime()
		
		# LOOP DO TIMER DE SPAWN NORMA
		if Global.wave <= 3:
			spawn_slime.start(randf_range(1, 1.5))
		
		# HARDCORE SPAWN START
		if Global.wave == 4:
			spawn_elite_slime.start(randf_range(1, 1.5))


func green_slime(life:float = 10):
	Global.enemy_left -= 1
	var new_slime = SLIME.instantiate()
	add_child(new_slime)
	spawn_pos.progress_ratio = randf()
	new_slime.global_position = new_position()
	new_slime.life_upd(life)


func red_slime(life:float = 40):
	Global.enemy_left -= 1
	var new_slime = RED_SLIME.instantiate()
	add_child(new_slime)
	spawn_pos.progress_ratio = randf()
	new_slime.global_position = new_position()
	new_slime.life_upd(life)


func blue_slime(life:float = 15):
	Global.enemy_left -= 1
	var new_slime = BLUE_SLIME.instantiate()
	add_child(new_slime)
	spawn_pos.progress_ratio = randf()
	new_slime.global_position = new_position()
	new_slime.life_upd(life)


func green_slime_boss():
	Global.boss = 1
	var boss = GREEN_SLIME_BOSS.instantiate()
	add_child(boss)
	spawn_pos.progress_ratio = randf()
	boss.global_position = new_position()


func red_slime_boss():
	Global.boss = 1
	var boss = RED_SLIME_BOSS.instantiate()
	add_child(boss)
	spawn_pos.progress_ratio = randf()
	boss.global_position = new_position()


func blue_slime_boss():
	Global.boss = 1
	var boss = BLUE_SLIME_BOSS.instantiate()
	add_child(boss)
	spawn_pos.progress_ratio = randf()
	boss.global_position = new_position()


# AJUSTA POSIÇÂO CERTA (para spawnar fora do mapa)
func new_position():
	spawn_pos.progress_ratio = randf()
	while spawn_pos.global_position.x > 1760 or spawn_pos.global_position.x < -1760 or spawn_pos.global_position.y > 1760 or spawn_pos.global_position.y < -1760:
		spawn_pos.progress_ratio = randf()
	
	return spawn_pos.global_position


# HARDCORE MODE !!!
func _on_spawn_elite_slime_timeout() -> void:
	if Global.Hardcore_Mode:
		# SPAWN AMOUNT / LOOP DO HARDCORE SPAWNS
		var sort:int = randi_range(min_spawn, max_spawn)
		for i in range(sort):
			create_elite_slime()
		if Global.wave <= 6:
			spawn_elite_slime.start(randf_range(1, 1.5))
		
		# FINAL DO HARDCORE
		else:
			print("Hardcore Finished!!!")
	else:
		spawn_elite_slime.start(randf_range(1, 1.5))
		# INICIA AS WAVES DO HARDCORE
		if !Global.enemy_left and Global.enemy_defeat >= Global.enemy_total and !Global.boss:
			Global.wave4()
			final.final()
	


func create_elite_slime():
	if Global.enemy_left > 0 and Global.boss == 0:
		# PURPLE SLIMES WAVE
		if Global.wave == 4:
			min_spawn = 3
			max_spawn = 10
			purple_slime()
		
		# BLACK SLIMES WAVE
		if Global.wave == 5:
			max_spawn = 10
			var sort:int = randi()  % 5
			if sort >= 1:
				purple_slime()
			else:
				black_slime()


	elif !Global.enemy_left and Global.enemy_defeat >= Global.enemy_total and !Global.boss:
		if Global.wave == 4:
			purple_slime_boss()
		if Global.wave == 5:
			black_slime_boss()
		Global.switch_wave(Global.wave)


func purple_slime(life:float = 65):
	Global.enemy_left -= 1
	var new_slime = PURPLE_SLIME.instantiate()
	add_child(new_slime)
	spawn_pos.progress_ratio = randf()
	new_slime.global_position = new_position()
	new_slime.life_upd(life)


func black_slime(life:float = 120):
	Global.enemy_left -= 1
	var new_slime = BLACK_SLIME.instantiate()
	add_child(new_slime)
	spawn_pos.progress_ratio = randf()
	new_slime.global_position = new_position()
	new_slime.life_upd(life)


func purple_slime_boss():
	Global.boss = 1
	var boss = PURPLE_SLIME_BOSS.instantiate()
	add_child(boss)
	spawn_pos.progress_ratio = randf()
	boss.global_position = new_position()


func black_slime_boss():
	Global.boss = 1
	var boss = BLACK_SLIME_BOSS.instantiate()
	add_child(boss)
	spawn_pos.progress_ratio = randf()
	boss.global_position = new_position()


func _final_boss_defeat():
	hardcore_final.final()
