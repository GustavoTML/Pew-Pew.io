extends Node

signal new_gun
signal level_up
signal xp_gain

# XP SETTINGS
var level = 1
var xp = 0
var xp_needed = calculate_xp_needed(level)
var level_up_pending:bool = false
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass

# AJUSTAR !!!!!!!!!!!!!!!
func calculate_xp_needed(level_current = level):
	var base_xp = 10
	var exponent = 1.2
	return int(base_xp * pow(level_current, exponent))


func add_xp(amount):
	xp += amount
	emit_signal("xp_gain")
	while xp >= xp_needed and !level_up_pending:
		xp -= xp_needed
		level += 1
		xp_needed = calculate_xp_needed(level)
		emit_signal("level_up")
		print("Level up! Novo level: ", level)
		if level != 3:
			if level % 3 == 0 or level == 2:
				level_up_pending = true
				emit_signal("new_gun")


func new_gun_signal():
	emit_signal("new_gun")


func reset_level():
	level = 1
	xp = 0
	xp_needed = calculate_xp_needed(level)
	level_up_pending = false
	emit_signal("xp_gain")
	emit_signal("level_up")
