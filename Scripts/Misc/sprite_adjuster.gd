extends Node2D

@export_category("Color")
@export var target_color : Color = Color(1, 1, 1, 0)
@export var color_factor : float = 1

@export var replacement : String = "0_"

@export_category("Scale")
@export var scale_factor : Vector2 = Vector2(0.7, 1.5)

func _ready() -> void:
	var namero : String = $"..".name
	namero = namero.replace(replacement, "")
	namero = "0." + namero    #should fall between 0 and 1
	var number : float = float(namero)
	
	#Color
	var final_color : Color = self_modulate.lerp(target_color, color_factor * (1 - number))
	self_modulate = final_color
	
	#Scale
	var final_scale : Vector2 = scale * number * randf_range(scale_factor.x, scale_factor.y) 
	scale = final_scale
	print(scale)
