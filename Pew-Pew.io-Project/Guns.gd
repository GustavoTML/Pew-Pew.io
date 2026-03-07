extends Node

# ARMAS
var ASSAULT_BRANCA = preload("res://player/assault_rifles/assault_branca/assault_rifle.tscn")
var M4A1 = preload("res://player/assault_rifles/m4a1/m4a1.tscn")
var BAZOOKA = preload("res://player/bazookas/bazooka/bazooka.tscn")
var VECTOR = preload("res://player/submachiniguns/vector/vector.tscn")
var SHOTGUN_BRANCA = preload("res://player/shotguns/shotgun_branca/shotgun.tscn")
var MINI_SHOTGUN = preload("res://player/shotguns/mini_shotgun/mini_shotgun.tscn")
var GOOD_SHOTGUN = preload("res://player/shotguns/good_shotgun/good_shotgun.tscn")
var GOLDEN_SNIPER = preload("res://player/snipes/golden_sniper/golden_sniper.tscn")
var SNIPER_GREEN = preload("res://player/snipes/sniper_green/sniper_green.tscn")
var P90 = preload("res://player/submachiniguns/p90/p_90.tscn")
var PISTOL = preload("res://player/pistol.tscn")
var MACHINEGUN = preload("res://player/heavyguns/machinegun/machinegun.tscn")
var FLAMETHROW = preload("res://player/heavyguns/flamethrow/flamethrow.tscn")
var ECHO = preload("res://player/shotguns/echo/echo.tscn")
var UZI = preload("res://player/pistols/uzi/uzi.tscn")
var GLOCK = preload("res://player/pistols/glock/glock.tscn")
var REVOLVER = preload("res://player/pistols/revolver/revolver.tscn")

# ICONS
var ASSAULT_BRANCA_ICON = preload("res://player/Icons/assault_branca_icon.tscn")
var PISTOL_ICON = preload("res://player/Icons/pistol_icon.tscn")
var VECTOR_ICON = preload("res://player/Icons/vector_icon.tscn")
var SHOTGUN_BRANCA_ICON = preload("res://player/Icons/shotgun_branca_icon.tscn")
var BAZOOKA_ICON = preload("res://player/Icons/bazooka_icon.tscn")
var GOLDEN_SNIPER_ICON = preload("res://player/Icons/golden_sniper_icon.tscn")
var GOOD_SHOTGUN_ICON = preload("res://player/Icons/good_shotgun_icon.tscn")
var M4A1_ICON = preload("res://player/Icons/m4a1_icon.tscn")
var MINI_SHOTGUN_ICON = preload("res://player/Icons/mini_shotgun_icon.tscn")
var P90_ICON = preload("res://player/Icons/p90_icon.tscn")
var SNIPER_GREEN_ICON = preload("res://player/Icons/sniper_green_icon.tscn")
var MACHINEGUN_ICON = preload("res://player/Icons/machinegun_icon.tscn")
var FLAMETHROW_ICON = preload("res://player/Icons/flamethrow_icon.tscn")
var ECHO_ICON = preload("res://player/Icons/echo_icon.tscn")
var UZI_ICON = preload("res://player/Icons/uzi_icon.tscn")
var GLOCK_ICON = preload("res://player/Icons/glock_icon.tscn")
var REVOLVER_ICON = preload("res://player/Icons/revolver_icon.tscn")

var all_gun_icon_map:Dictionary = {
	ASSAULT_BRANCA: ASSAULT_BRANCA_ICON,
	SHOTGUN_BRANCA: SHOTGUN_BRANCA_ICON,
	PISTOL: PISTOL_ICON,
	VECTOR:VECTOR_ICON,
	M4A1: M4A1_ICON,
	BAZOOKA: BAZOOKA_ICON,
	MINI_SHOTGUN: MINI_SHOTGUN_ICON,
	GOOD_SHOTGUN: GOOD_SHOTGUN_ICON,
	GOLDEN_SNIPER: GOLDEN_SNIPER_ICON,
	SNIPER_GREEN: SNIPER_GREEN_ICON,
	P90: P90_ICON,
	MACHINEGUN:MACHINEGUN_ICON,
	FLAMETHROW:FLAMETHROW_ICON,
	ECHO: ECHO_ICON,
	UZI:UZI_ICON,
	GLOCK:GLOCK_ICON,
	REVOLVER:REVOLVER_ICON,
}

var all_gun_names_map:Dictionary = {
	"Assault_Rifle": ASSAULT_BRANCA ,
	"Shotgun": SHOTGUN_BRANCA,
	"Pistol": PISTOL,
	"Vector": VECTOR,
	"M4A1": M4A1,
	"Bazooka": BAZOOKA,
	"Mini_Shotgun": MINI_SHOTGUN,
	"Good_Shotgun": GOOD_SHOTGUN,
	"Golden_Sniper": GOLDEN_SNIPER,
	"Sniper_Green": SNIPER_GREEN,
	"P90": P90,
	"Machinegun": MACHINEGUN,
	"Flamethrow": FLAMETHROW,
	"Echo": ECHO,
	"Uzi": UZI,
	"Glock": GLOCK,
	"Revolver": REVOLVER,
}

var all_icon_names_map:Dictionary = {
	"Assault_Rifle": ASSAULT_BRANCA_ICON,
	"Shotgun": SHOTGUN_BRANCA_ICON,
	"Pistol": PISTOL_ICON,
	"Vector": VECTOR_ICON,
	"M4A1": M4A1_ICON,
	"Bazooka": BAZOOKA_ICON,
	"Mini_Shotgun": MINI_SHOTGUN_ICON,
	"Good_Shotgun": GOOD_SHOTGUN_ICON,
	"Golden_Sniper": GOLDEN_SNIPER_ICON,
	"Sniper_Green": SNIPER_GREEN_ICON,
	"P90": P90_ICON,
	"Machinegun": MACHINEGUN_ICON,
	"Flamethrow": FLAMETHROW_ICON,
	"Echo": ECHO_ICON,
	"Uzi": UZI_ICON,
	"Glock": GLOCK_ICON,
	"Revolver": REVOLVER_ICON,
}


var communs:Dictionary = {
	ASSAULT_BRANCA: ASSAULT_BRANCA_ICON,
	SHOTGUN_BRANCA: SHOTGUN_BRANCA_ICON,
	UZI: UZI_ICON,
	REVOLVER: REVOLVER_ICON,
}
var raros:Dictionary = {
	VECTOR:VECTOR_ICON,
	MINI_SHOTGUN: MINI_SHOTGUN_ICON,
	GOOD_SHOTGUN: GOOD_SHOTGUN_ICON,
	SNIPER_GREEN: SNIPER_GREEN_ICON,
}
var epics:Dictionary = {
	P90: P90_ICON,
	M4A1: M4A1_ICON,
	BAZOOKA: BAZOOKA_ICON,
	GOLDEN_SNIPER: GOLDEN_SNIPER_ICON,
}
var legendary:Dictionary = {
	MACHINEGUN:MACHINEGUN_ICON,
	FLAMETHROW:FLAMETHROW_ICON,
	ECHO:ECHO_ICON
}

var pistols:Dictionary = {
	PISTOL: PISTOL_ICON,
	UZI: UZI_ICON,
	GLOCK: GLOCK_ICON,
	REVOLVER: REVOLVER_ICON,
}

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func sort():
	var num_sort = randi_range(1, 100)
	if num_sort <= 60:
		return communs.keys().pick_random()
	elif num_sort <= 90:
		return raros.keys().pick_random()
	elif num_sort <= 97:
		return epics.keys().pick_random()
	else:
		return legendary.keys().pick_random()


func sort_pistol():
	return pistols.keys().pick_random()
