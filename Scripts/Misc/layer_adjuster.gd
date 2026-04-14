extends Node2D


@export var replacement : String = "0_"
@export var start_index : int = -5

func _ready() -> void:
	#GetChildren
	var children = get_children()
		
	for item : Parallax2D in children:
		#String to number
		var namero : String = item.name
		namero = namero.replace(replacement, "")
		var number : int = int(namero)
		
		#Parallaxing
		item.scroll_scale = Vector2(number, number) * 0.1
		
		#Z Indexing
		item.z_index = start_index - get_child_count() + number
