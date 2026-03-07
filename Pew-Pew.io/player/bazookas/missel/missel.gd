extends Area2D

const EXPLOSION = preload("res://effect/esplosions/circle_explosion/circle_explosion.tscn")

var direction:Vector2
var speed:float = 600
var max_range = 2000
var distance = 0
var damage:float = 5


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	direction = Vector2.RIGHT.rotated(rotation)
	position += direction * speed * delta
	distance += speed * delta
	if distance > max_range:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	create_explosion()
	queue_free()


func create_explosion():
	var new_explosion = EXPLOSION.instantiate()
	get_parent().call_deferred("add_child", new_explosion)
	new_explosion.global_position = global_position
