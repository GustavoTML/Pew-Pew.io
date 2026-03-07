extends Area2D
@onready var light_2: PointLight2D = $Light2
@onready var sprite_2: Sprite2D = $Sprite2

var direction:Vector2
var speed:float = 700
var max_range = 600
var distance = 0
var damage:float = 10

var is_shotgun:bool = false
var is_assault:bool = false
var is_pistol:bool = false
var is_snipe:bool = false
var m4a1:bool = false

var is_flame:bool = false

var penetration:int = 0


func _ready() -> void:
	if Global.Hardcore_Mode and !is_flame:
		light_2.visible = true
	else:
		light_2.visible = false



func _process(delta: float) -> void:
	if is_flame:
		penetration = 10
		light_2.enabled = false
		sprite_2.visible = false
		is_flame = false
	scale = Vector2(1, 1)
	direction = Vector2.RIGHT.rotated(rotation)
	position += direction * speed * delta
	distance += speed * delta
	if m4a1:
		penetration = 1
		m4a1 = false
	if distance > max_range:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
		if is_shotgun:
			if distance > 75:
				if penetration <= 0:
					queue_free()
				else:
					penetration -= 1
		elif is_snipe:
			pass
		elif penetration > 0:
			penetration -= 1
		else:
			queue_free()
