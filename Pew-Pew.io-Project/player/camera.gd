extends Camera2D
@onready var zoom_anim: AnimationPlayer = $Zoom

var shakenoise: FastNoiseLite

var zoom_state:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shakenoise = FastNoiseLite.new()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func camerashake(intensity):
	var camera_tween = create_tween()
	camera_tween.tween_method(shake, intensity, 1, 0.5)


func shake(intensity):
	var cameraoffset = shakenoise.get_noise_1d(Time.get_ticks_msec()) * intensity
	offset.x = cameraoffset
	offset.y = cameraoffset


func zoom_in():
	if !zoom_state:
		zoom_state = true
		zoom_anim.play("zoom")
func zoom_out():
	if zoom_state:
		zoom_state = false
		zoom_anim.play_backwards("zoom")
