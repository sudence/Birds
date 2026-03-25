extends CharacterBody2D

@export_category("Speed")
@export var min_speed : float = 200
const gravity : float = 500

@export var max_y_velocity : float = 550
@export var glide_acceleration : float = 700
@export var glide_up_draft : float = 200
@export var drag : float = 300
var gliding: bool = false

@export_category("Flapping")
@export var flap_force : float = 500
@onready var flap_tap : Timer = $FlapTap
var flap_doubletap_time : float = 0.45
var flapped : bool = false

@onready var flap_regen_timer: Timer = $FlapRegen
@export var flap_regen_time : float = 3
@export var max_flaps: int = 3
var flaps: int = 0

@export_category("Misc")
@onready var trail: Line2D = $Sprite2D/Line2D
@onready var trail_timer: Timer = $TrailTimer
@export var trail_time : float = 0.2

@export var flap_bars : Array[Control]
var feather_bar : Array[BarController]

func _ready() -> void:
	trail.clear_points()
	flaps = max_flaps
	
	print(flap_bars.size())
	for i in range(0 , flap_bars.size()):
		feather_bar.append(flap_bars[i].get_child(0))
		print(flap_bars[i].name)
	
	trail_timer.wait_time = trail_time
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Flap"):
		gliding = true
		if !flap_tap.is_stopped() and flaps > 0:
			flap()
			flapped = true
		
		if !flapped: 
			flap_tap.start(flap_doubletap_time)
		flapped = false
	elif event.is_action_released("Flap"):
		gliding = false
	
	if event.is_action_pressed("reset"):
		get_tree().reload_current_scene()

func _process(delta: float) -> void:
	if flap_regen_timer.is_stopped() and flaps < max_flaps:
		flap_regen_timer.start(flap_regen_time)
	
	if !flap_regen_timer.is_stopped():
		feather_bar[flaps].val =  1 - flap_regen_timer.time_left/flap_regen_time

func _physics_process(delta: float) -> void:
	if gliding:
		if velocity.y > 0:
			velocity.x += glide_acceleration * delta
		velocity.y -= glide_up_draft * delta
	else:
		velocity.x = move_toward(velocity.x, min_speed, drag * delta)
		
		if !is_on_floor():
			velocity.y += gravity * delta
		else:
			velocity.y = 0
	
	move_and_slide();
	
	if velocity.y < -max_y_velocity:
		gliding = false
	
	rotation = lerp_angle(rotation, atan2(velocity.y, velocity.x), 10 * delta)
	
	#Trail
	trail_timer.wait_time = trail_time - (trail_time - 0.01) * clamp(velocity.length()/5000, 0, 1)
	
	trail.add_point(global_position)
	if trail_timer.is_stopped():
		trail.remove_point(0)

func flap():
	velocity.y -= flap_force
	flap_tap.stop()
	
	flaps -= 1
	
	feather_bar[flaps].val = 0
	if flaps < max_flaps - 1:
		feather_bar[flaps + 1].val = 0

func _on_flap_regen_timeout() -> void:
	flaps += 1
