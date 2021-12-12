extends Button

export(Texture) var cross_texture
export(Texture) var validate_texture

onready var overlay: TextureRect = $Overlay
var card_name: String = "?"
var card_index: int
var select_type: int


func _ready():
	text = card_name
	pressed = false


func set_card_name(name: String) -> void:
	card_name = name
	text = name


func set_card_index(_card_index: int) -> void:
	card_index = _card_index


func set_select_type(_select_type: int) -> void:
	select_type = _select_type
	if select_type == Action.SELECT_TYPE.KEEP:
		overlay.texture = validate_texture
	else:
		overlay.texture = cross_texture


func set_pressed(status: bool) -> void:
	pressed = status
	if pressed:
		overlay.show()
	else:
		overlay.hide()


func hide_overlay() -> void:
	overlay.hide()
