extends Control

@onready var xp_bar: ProgressBar = $Xp_Bar
@onready var level_text: Label = $Xp_Bar/Level_Text
@onready var pause: Button = $Pause
@onready var pause_hud: Control = %Pause

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	XP.level_up.connect(_update_level)
	XP.xp_gain.connect(_update_xpbar)
	visible = true
	xp_bar.max_value = XP.calculate_xp_needed()
	xp_bar.value = XP.xp
	level_text.text = "level " + str(XP.level - 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _update_xpbar():
	xp_bar.value = XP.xp


func _update_level():
	xp_bar.max_value = XP.calculate_xp_needed()
	xp_bar.value = XP.xp
	level_text.text = "level " + str(XP.level - 1)


#BOTAO COM FOCUS ERRADO !!!!!!!!!!!!!
func _on_pause_pressed() -> void:
	pause_hud.pausar()


func _on_fullscreen_pressed() -> void:
	Global.fullscreen()
