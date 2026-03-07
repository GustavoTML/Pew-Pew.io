extends Area2D
@onready var light_2: PointLight2D = $Light2
@onready var monitoring_area: Area2D = %Monitoring_Area
@onready var bullet: Polygon2D = $Bullet

var direction:Vector2
var speed:float = 1300
var max_range = 3500
var distance = 0
var damage:float = 100

var penetration:int = 20


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	direction = Vector2.RIGHT.rotated(rotation)
	position += direction * speed * delta
	distance += speed * delta
	if distance > max_range:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
		if penetration > 0:
			penetration -= 1
			var enemies = monitoring_area.get_overlapping_bodies()
			enemies.erase(body)
			if enemies.size() > 0:
				look_at(enemies[0].global_position)
			else:
				queue_free()
			
		else:
			queue_free()
