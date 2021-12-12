extends ColorRect

signal finished_fading()

export var is_faded: bool = false setget set_is_faded, get_is_faded
export var duration: float = 0.2
var alpha: float = 1.0


func set_is_faded(new_state: bool) -> void:
	is_faded = new_state
	set_process(true)


func get_is_faded() -> bool:
	return is_faded


func _process(delta) -> void:
	if is_faded:
		if alpha < 1.0:
			alpha = clamp(alpha + (delta / duration), 0.0, 1.0)
		else:
			set_process(false)
			emit_signal("finished_fading")
	else:
		if alpha > 0.0:
			alpha = clamp(alpha - (delta / duration), 0.0, 1.0)
		else:
			set_process(false)
			emit_signal("finished_fading")
	
	modulate = Color(1.0, 1.0, 1.0, alpha)
	visible = alpha >= 0.0
