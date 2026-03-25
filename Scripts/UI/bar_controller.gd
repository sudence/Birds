extends ProgressBar

class_name BarController

@export var m_val : float = 1
var val : float = 0

@export var smoothing : float = 2

func _ready() -> void:
	val = m_val
	
	max_value = m_val
	value = val

func _process(delta: float) -> void:
	value = val
