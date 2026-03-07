extends Node

signal Final_Boss_Defeat

var death:int = 0
var total_damage_take:float = 0
# total de inimigos abatidos em todas as waves
var total_enemy_defeat:int = 0
# inimigos derrotados na wave
var enemy_defeat:int = 0
# Quantidade de inimigos a serem spawnados na wave
var enemy_left:int
# Quantidade de inimigos tatais da wave
var enemy_total:int
# wave
var wave:int = 1
# > 0 para existe boss e == 0 para nao tem bos
var boss:int = 0

var Hardcore_Mode:bool = false

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("FULLSCREEN"):
		fullscreen()


func fullscreen():
	JavaScriptBridge.eval("""
		var canvas = document.getElementsByTagName('canvas')[0];
		if (document.fullscreenElement) {
			document.exitFullscreen();
		} else {
			if (canvas.requestFullscreen) {
				canvas.requestFullscreen();
			}
		}
	""")


func switch_wave(wave_n:int = wave):
	if wave_n == 1:
		wave2()
	elif wave_n == 2:
		wave3()
	elif wave_n == 3:
		wave4()
	elif wave_n == 4:
		wave5()
	elif wave_n == 5:
		wave6()
	elif wave_n == 6:
		wave = 7
		final()


func wave1():
	wave = 1
	enemy_defeat = 0
	enemy_left = 100 + randi_range(5, 30)
	enemy_total = enemy_left


func wave2():
	wave = 2
	enemy_defeat = 0
	enemy_left = 120 + randi_range(5, 30)
	enemy_total = enemy_left


func wave3():
	wave = 3
	enemy_defeat = 0
	enemy_left = 140 + randi_range(5, 30)
	enemy_total = enemy_left


func wave4():
	wave = 4
	enemy_defeat = 0
	enemy_left = 120 + randi_range(5, 30)
	enemy_total = enemy_left


func wave5():
	wave = 5
	enemy_defeat = 0
	enemy_left = 120 + randi_range(5, 30)
	enemy_total = enemy_left


func wave6():
	wave = 6
	enemy_defeat = 0
	enemy_left = 200 + randi_range(5, 30)
	enemy_total = enemy_left


func final(): 
	print(total_enemy_defeat)


func reset():
	Hardcore_Mode = false
	total_damage_take = 0
	total_enemy_defeat = 0
	wave = 1
	boss = 0
	enemy_defeat = 0
	enemy_left = 0
	enemy_total = 0


func boss_defeat():
	emit_signal("Final_Boss_Defeat")
