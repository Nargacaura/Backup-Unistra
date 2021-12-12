extends CanvasLayer

var cards_text = {
	Card.CARD_TYPE.HIDDEN : preload("res://resources/Cards/Back.png"),
	Card.CARD_TYPE.DUKE : preload("res://resources/Cards/Duchess1.png"),
	Card.CARD_TYPE.ASSASSIN : preload("res://resources/Cards/Assassin1.png"),
	Card.CARD_TYPE.CONTESSA : preload("res://resources/Cards/Comtessa1.png"),
	Card.CARD_TYPE.CAPTAIN : preload("res://resources/Cards/Captain1.png"),
	Card.CARD_TYPE.AMBASSADOR : preload("res://resources/Cards/Ambassador1.png"),
	Card.CARD_TYPE.INQUISITOR : preload("res://resources/Cards/Inquisitor1.png")
}
onready var default_font = preload("res://fonts/default.tres")
onready var cards_node: Node = $"Controller/Cards"
onready var options_node: Node = $"Controller/Options"

var cards: Array
var options: Array
var selection: Array
var count: int
var max_select: int

const selected_card_color: Color = Color(1,1.4,1,1)
const selected_card_hover_color: Color = Color(1.3,1.8,1.3,1)
const card_hover_color: Color = Color(1.3,1.3,1.3,1)
const card_color: Color = Color(1,1,1,1)

signal selection_done(cards_selected)


func _ready():
	set_scale(Vector2(0.6*0.67,0.8*0.715))
	set_offset(Vector2(109*0.67,50*0.715))
	#rect_position = Vector2(0,-300)
	clean_all()

func connect_selector(view):
	self.connect("selection_done",view,"_on_selection_done")

func clean_all():
	selection = []
	for i in count:
		remove_card(cards.size()-1)
	if cards_node != null:
		for child in cards_node.get_children():
			child.disconnect("pressed",self,"on_pressed")
			child.queue_free()
	if options_node != null:
		for child in options_node.get_children():
			child.disconnect("pressed",self,"on_pressed")
			child.queue_free()
	count = 0

func remove_card(id):
	cards_node.remove_child(cards[id])
	cards[id].disconnect("pressed",self,"on_pressed")
	cards[id].queue_free()
	cards.remove(id)

func remove_option(id):
	options_node.remove_child(options[id])
	options[id].disconnect("pressed",self,"on_pressed")
	options[id].queue_free()
	options.remove(id)

func on_pressed(id,card_type = Card.CARD_TYPE.HIDDEN):
	print("clicked : "+str(id)+" "+str(card_type))
	if id in selection:
		selection.erase(id)
		cards[id].modulate = card_color
	else:
		selection.append(id)
		cards[id].modulate = selected_card_color
		if selection.size() == max_select:
			emit_signal("selection_done",selection)
			clean_all()

func on_option_pressed(id):
	print("clicked : "+str(id))
	if id in selection:
		selection.erase(id)
	else :
		selection.append(id)
		if selection.size() == max_select:
			emit_signal("selection_done",selection,true)
			clean_all()

func on_hovered(card):
	if card.modulate in [selected_card_color,selected_card_hover_color]:
		card.set_modulate(selected_card_hover_color)
	else:
		card.set_modulate(card_hover_color)

func on_hover_end(card):
	if card.modulate in [selected_card_color,selected_card_hover_color]:
		card.set_modulate(selected_card_color)
	else:
		card.set_modulate(card_color)

func disable(set):
	$Controller.set_visible(not set)
	if set :
		clean_all()

func add_card(card,qty_select)-> void:
	max_select = qty_select
	var new_card = TextureButton.new()
	new_card.set_normal_texture(cards_text[card._type])
	var _s = new_card.connect("pressed",self,"on_pressed",[count,card._type])

	_s = new_card.connect("mouse_entered",self,"on_hovered",[new_card])
	_s = new_card.connect("mouse_exited",self,"on_hover_end",[new_card])

	new_card.set_stretch_mode(TextureButton.STRETCH_KEEP_CENTERED)
	new_card.set_expand(false)
	cards_node.add_child(new_card)
	cards.append(new_card)
	count += 1
	#position = OS.get_window_size()*0.5# - Vector2(100,0)*0.5*count-Vector2(0,150)
	cards_node.rect_size = Vector2(70*0.67,0)*count + Vector2(0,100*0.715)

func add_option(text = "Unknown option.", id = 0):
	var new_option = Button.new()
	new_option.text = text
	new_option.theme = Theme.new()
	new_option.theme.set_default_font(default_font)
	#new_option.set_h_size_flags(Control.SIZE_EXPAND_FILL)
	var _s = new_option.connect("pressed", self, "on_option_pressed", [id])
	new_option.set_size(Vector2(400*0.67,80*0.715))
	options_node.rect_size = Vector2(300*0.67,0) + Vector2(0,70*0.715)*count
	options_node.add_child(new_option)
	options.insert(id, text)

func set_title(msg = "Please choose a card."):
	$Controller/Text.set_text(msg)

func get_selection():
	return selection
