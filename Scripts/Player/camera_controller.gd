extends Camera2D

@onready var player: CharacterBody2D = $".."

@export var zoom_smoothing : float = 1
@export var offset_curve : Curve
@export var zoom_curve : Curve

@onready var raycast: RayCast2D = $"../CamCast"
var raycast_height : float

func _ready() -> void:
	raycast_height = 0.5 * 1080/ zoom_curve.min_value
	
	raycast.target_position = Vector2(0, raycast_height) 

func _process(delta: float) -> void:
	#Zooming
	var zoomer : float = 0
	var p_vel_ratio : float = clamp(player.velocity.length()/5000, 0, 1)
	
	raycast.position = player.position
	if raycast.is_colliding():
		var height_ratio : float = raycast.position.distance_to(raycast.get_collision_point()) / raycast_height
		zoomer = zoom_curve.sample(height_ratio + p_vel_ratio)
	else:
		zoomer = zoom_curve.min_value
	
	offset.x = lerp(offset.x, offset_curve.sample(zoomer), zoom_smoothing * delta)
	zoom = zoom.lerp(Vector2(zoomer, zoomer), zoom_smoothing * delta)
