extends Area2D

@onready var light_2: PointLight2D = $Light2
var direction:Vector2
var speed:float = 450
var max_range = 1200
var distance = 0
var damage:float = 15
var poison_dam = 2.5
var can_poison:bool = false
var poison_timer:float = 5

func _ready() -> void:
	if Global.Hardcore_Mode:
		light_2.visible = true
	else:
		light_2.visible = false



func _process(delta: float) -> void:
	if can_poison:
		$Sprite.modulate = Color(0.752, 0.0, 0.752)
	else:
		$Sprite.modulate = Color(1.0, 0.914, 0.0)
	direction = Vector2.RIGHT.rotated(rotation)
	position += direction * speed * delta
	distance += speed * delta
	if distance > max_range:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
		
	if can_poison and body.has_method("get_poison"):
		body.get_poison(poison_dam, poison_timer)
	
	queue_free()
