extends Control

@onready var player = get_node("/root/World/Player")
@onready var nivel: Label = %Nivel
@onready var enemies_defeat: Label = %Enemies_Defeat
@onready var deaths: Label = %Deaths
@onready var dano: Label = %Dano
@onready var arma_1: Label = $NinePatchRect/VBoxContainer/Armas/Arma_1
@onready var arma_2: Label = $NinePatchRect/VBoxContainer/Armas/Arma_1/Arma_2

var updated_1:bool = true
var updated_2:bool = true

var gun_1
var gun_2
var gun_name1
var gun_name2
var gun_rarity1
var gun_rarity2
var gun_color1
var gun_color2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !updated_1:
		if gun_1:
			gun_color1 = gun_1.color_box
			if gun_color1:
				arma_1.self_modulate = gun_color1
			gun_rarity1 = gun_1.rarity
			if gun_rarity1:
				arma_1.text = str(gun_name1) + " (" + str(gun_rarity1) + ")"
				updated_1 = false
		else:
			arma_1.text = "SEM ARMA"
	
	if !updated_2:
		if gun_2:
			gun_color2 = gun_2.color_box
			if gun_color2:
				arma_2.self_modulate = gun_color2
			gun_rarity2 = gun_2.rarity
			if gun_rarity2:
				arma_2.text = str(gun_name2) + " (" + str(gun_rarity2) + ")"
				updated_2 = false
		else:
			arma_2.text = "SEM ARMA"


func get_informations():
	get_guns()
	nivel.text = "NIVEL: " + str(XP.level)
	enemies_defeat.text = "INIMIGOS DERRODTADOS: " + str(Global.total_enemy_defeat)
	deaths.text = "MORTES: " + str(Global.death)
	dano.text = "DANO SOFRIDO: " + str(int(Global.total_damage_take))


func get_guns():
	var new_gun_1
	var new_gun_2
	if player.gun_left:
		gun_name1 = player.gun_left
		new_gun_1 = Guns.all_icon_names_map[player.gun_left]
		gun_1 = new_gun_1.instantiate()
		call_deferred("add_child", gun_1)
		gun_1.set_deferred("visible", false)
	if player.gun_right:
		gun_name2 = player.gun_right
		new_gun_2 = Guns.all_icon_names_map[player.gun_right]
		gun_2 = new_gun_2.instantiate()
		call_deferred("add_child", gun_2)
		gun_2.set_deferred("visible", false)
	
	updated_1 = false
	updated_2 = false
	
	
