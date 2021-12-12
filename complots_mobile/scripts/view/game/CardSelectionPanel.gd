extends ColorRect

signal selected_card_validated(selected_cards_indexes)

export(PackedScene) var SelectCard = null

onready var title: Label = $VBoxContainer/Label
onready var cards_container: Label = $VBoxContainer/CardsContainer
onready var validate_btn: Button = $VBoxContainer/CenterContainer/ValidateBtn

var connected_node_callback: String
var connected_node: Node = null
var pressed_card_count: int = 0
var _ret # To Stop Warnings


func _ready():
	pressed_card_count = 0
	validate_btn.disabled = true
	_ret = validate_btn.connect("pressed", self, "_on_ValidateBtn_pressed")


func _on_ValidateBtn_pressed() -> void:
	AudioManager.play_sfx(AudioManager.get_random_button_click())
	emit_signal("selected_card_validated", get_selected_cards_indexes())
	hide()
	set_process(false)
	pressed_card_count = 0
	# clean Select Menu
	call_deferred("hide_select_menu")

func show_select_menu(cards: Array, qty: int, text: String, select_type: int, calling_node: Node, callback: String, override_values: Array = []) -> void:
	# Reset pressed card counter
	pressed_card_count = 0
	# Disable validate button by default
	validate_btn.disabled = true
	
	# Set text
	title.text = text
	
	# Disconnect previous Node
	disconnect_node()
	
	# Connect callback
	connected_node = calling_node
	connected_node_callback = callback
	_ret = self.connect("selected_card_validated", calling_node, callback)
	
	# Add cards to the container
	var container_card_index: int = 0
	if override_values == []:
		for i in cards.size():
			if !cards[i].is_dead():
				var card = SelectCard.instance()
				cards_container.add_child(card)
				card.hide_overlay()
				card.set_card_name(cards[i].get_name().left(2))
				card.set_card_index(i)
				card.set_select_type(select_type)
				_ret = card.connect("pressed", self, "_on_SelectCard_pressed", [container_card_index, qty])
				container_card_index += 1
	else:
		for i in override_values.size():
			var card = SelectCard.instance()
			cards_container.add_child(card)
			card.hide_overlay()
			card.set_card_name(override_values[i])
			card.set_card_index(i)
			card.set_select_type(select_type)
			_ret = card.connect("pressed", self, "_on_SelectCard_pressed", [container_card_index, qty])
			container_card_index += 1
	
	# Activate Selection Panel
	show()
	set_process(true)


func _on_SelectCard_pressed(container_card_index: int, qty: int) -> void:
	AudioManager.play_sfx(AudioManager.get_random_button_click())
	var was_card_pressed: bool = !cards_container.get_child(container_card_index).pressed
	cards_container.get_child(container_card_index).set_pressed(!was_card_pressed)
	pressed_card_count += 1 if not was_card_pressed else -1
	
	if pressed_card_count > qty:
		var i: int = 0
		for card in cards_container.get_children():
			if card.pressed and i != container_card_index:
				card.set_pressed(false)
				pressed_card_count -= 1
			if pressed_card_count <= qty:
				break
			i += 1
	
	if pressed_card_count == qty:
		validate_btn.disabled = false
	else:
		validate_btn.disabled = true


func get_selected_cards_indexes() -> Array:
	var selected_cards_indexes: Array = []
	for card in cards_container.get_children():
		if card.pressed:
			selected_cards_indexes.append(card.card_index)
	return selected_cards_indexes


func clean_cards() -> void:
	for card in cards_container.get_children():
		card.queue_free()


func disconnect_node() -> void:
	# Disconnect previous Node
	if connected_node:
		if self.is_connected("selected_card_validated", connected_node, connected_node_callback):
			self.disconnect("selected_card_validated", connected_node, connected_node_callback)
		connected_node = null


func hide_select_menu() -> void:
	clean_cards()
	disconnect_node()
	hide()
	set_process(false)

