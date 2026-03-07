extends Control

@onready var hand_seletor_anim: AnimationPlayer = %Hand_seletor_Anim
@onready var left_option: Button = %Left_Option
@onready var right_option: Button = %Right_Option

var hand_selected:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_left_option_pressed() -> void:
	hand_selected = 1
	hand_seletor_anim.play("RESET")
	get_parent().add_new_gun()


func _on_right_option_pressed() -> void:
	hand_selected = 2
	hand_seletor_anim.play("RESET")
	get_parent().add_new_gun()


func update_all():
	left_option.update()
	right_option.update()
