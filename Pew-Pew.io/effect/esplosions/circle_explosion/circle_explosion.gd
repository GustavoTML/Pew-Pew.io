extends Area2D

@onready var animator: AnimationPlayer = $Animator
@onready var anim: AnimatedSprite2D = %Anim

var damage:float = 70

func _ready() -> void:
	pass # Replace with function body.



func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)


func _on_knockback_area_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(8)
	if body.has_method("knockback"):
		body.knockback(global_position, 700)


func _on_animator_animation_finished(anim_name: StringName) -> void:
	queue_free()
