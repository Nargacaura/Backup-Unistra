extends TextureRect

export(String) var title: String = "Title" setget set_title
export(String) var text: String = "Achievement text" setget set_text
export(int) var current_amount: int = 0 setget set_current_amount
export(int) var max_amount: int = 100 setget set_max_amount
export(Color) var medal_color: Color = Color("#fbae17")

onready var medal_node: Label = $Medal
onready var title_node: Label = $Content/Header/ItemTitle/Title
onready var text_node: Label = $Content/ContentContainer/Content/Text
onready var slider: HSlider = $Content/ContentContainer/Content/Slider/HSlider
onready var current_amount_node: Label = $Content/ContentContainer/Content/Slider/BottomText/Amount
onready var max_amount_node: Label = $Content/ContentContainer/Content/Slider/BottomText/MaxAmount


func _ready() -> void:
	slider.min_value = 0
	slider.step = 1
	slider.editable = false
	slider.scrollable = false
	medal_node.hide()


func set_title(_title: String) -> void:
	title = _title
	title_node.text = _title


func set_text(_text: String) -> void:
	text = _text
	text_node.text = _text


func set_current_amount(_current_amount: int) -> void:
	if _current_amount < 0:
		return
	current_amount = _current_amount
	current_amount_node.text = str(_current_amount)
	slider.value = _current_amount
	
	if current_amount >= max_amount:
		slider.value = max_amount
		medal_node.modulate = medal_color
		medal_node.show()
	else:
		medal_node.hide()


func set_max_amount(_max_amount: int) -> void:
	if _max_amount < 0:
		return
	max_amount = _max_amount
	max_amount_node.text = str(_max_amount)
	slider.max_value = _max_amount
	
	if current_amount >= max_amount:
		slider.value = max_amount
		medal_node.modulate = medal_color
		medal_node.show()
	else:
		medal_node.hide()
	
