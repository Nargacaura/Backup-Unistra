extends ColorRect

export(StyleBoxFlat) var alive_card_style_box = null
export(StyleBoxFlat) var dead_card_style_box = null
export(Array, Texture) var cards_textures = []

onready var buttons_container: Node = $Buttons
onready var buttons: Array = $Buttons.get_children()
onready var actions_button: Node = $Buttons/Actions_Button
onready var bluffs_button: Node = $Buttons/Bluffs_Button
onready var coup_button: Node = $Buttons/Coup_Button
onready var actions_container: Node = $Contrainer/Actions_Container
onready var bluffs_container: Node = $Bluffs_Container

onready var reaction_container: Node = $Reaction_Buttons
onready var reaction_buttons: Array = $Reaction_Buttons.get_children()
onready var doubt_button: Node = $Reaction_Buttons/Doubt_Button
onready var pass_button: Node = $Reaction_Buttons/Pass_Button
onready var counter_button: Node = $Reaction_Buttons/Counter_Button

onready var cards_container: Node = $Contrainer/Cards
export(String) var default_card_text: String = "?"

func _ready():
	_set_active(actions_container, false)
	_set_active(bluffs_container, false)
	buttons[1].disabled = true
	buttons[0].connect("pressed", self, "_on_button_pressed", [0])
	buttons[1].connect("pressed", self, "_on_button_pressed", [1])
	buttons[2].connect("pressed", self, "_on_button_pressed", [2])
	
	reaction_buttons[0].connect("pressed", self, "_on_reaction_button_pressed", [0])
	reaction_buttons[1].connect("pressed", self, "_on_reaction_button_pressed", [1])
	reaction_buttons[2].connect("pressed", self, "_on_reaction_button_pressed", [2])


func _update_buttons(index: int) -> void:
	for i in buttons.size():
		buttons[i].pressed = buttons[i].pressed and i == index


func _set_active(node: Node, status: bool) -> void:
	node.set_process(status)
	if status:
		node.show()
	else:
		node.hide()


func _clear_containers() -> void:
	for row in actions_container.get_children():
		row.queue_free()
	for row in bluffs_container.get_children():
		row.queue_free()


func _on_button_pressed(index: int) -> void:
	AudioManager.play_sfx(AudioManager.get_random_button_click())
	_update_buttons(index)
	match index:
		0:
			_set_active(actions_container, buttons[index].pressed)
			_set_active(bluffs_container, false)
		2: 
			_set_active(actions_container, false)
			_set_active(bluffs_container, buttons[index].pressed)
		_: 
			_set_active(actions_container, false)
			_set_active(bluffs_container, false)


func _update_reaction_buttons(index: int) -> void:
	for i in reaction_buttons.size():
		reaction_buttons[i].pressed = reaction_buttons[i].pressed and i == index


func _on_reaction_button_pressed(index: int) -> void:
	AudioManager.play_sfx(AudioManager.get_random_button_click())
	_update_reaction_buttons(index)
	match index:
		2: 
			_set_active(actions_container, false)
			_set_active(bluffs_container, reaction_buttons[index].pressed)
		_: 
			_set_active(actions_container, false)
			_set_active(bluffs_container, false)


func set_active_actions(status: bool) -> void:
	actions_button.disabled = !status
	bluffs_button.disabled = !status
	actions_button.pressed = false
	bluffs_button.pressed = false
	_set_active(actions_container, false)
	_set_active(bluffs_container, false)


func set_active_coup(status: bool) -> void:
	coup_button.disabled = !status


func start_reaction_phase() -> void:
	counter_button.disabled = true
	doubt_button.disabled = true
	_set_active(actions_container, false)
	_set_active(bluffs_container, false)
	_set_active(reaction_container, true)
	_set_active(buttons_container, false)


func end_reaction_phase() -> void:
	_update_reaction_buttons(-1)
	_set_active(actions_container, false)
	_set_active(bluffs_container, false)
	_clear_containers()
	_set_active(buttons_container, true)
	_set_active(reaction_container, false)


func enable_counter() -> void:
	counter_button.disabled = false


func enable_doubt() -> void:
	doubt_button.disabled = false


func set_card_text(card_index: int, text: String) -> void:
	if card_index < cards_container.get_child_count():
		cards_container.get_child(card_index).text = text


func add_card(_card_name: String, player_hand: Array) -> void:
	update_hand_view(player_hand)


func set_card_style(card_node: Node, is_dead: bool) -> void:
	card_node.set("custom_styles/normal", dead_card_style_box if is_dead else alive_card_style_box)


func remove_card(_card_index: int, player_hand: Array) -> void:
	update_hand_view(player_hand)


func kill_card(card_index: int) -> void:
	if card_index < cards_container.get_child_count():
		var card_node: Label = cards_container.get_child(card_index)
		set_card_style(card_node, true)


func update_hand_view(player_hand: Array) -> void:
	var index: int = 0
	var is_dead: bool = false
	for card_node in cards_container.get_children():
		if index < player_hand.size():
			card_node.text = player_hand[index].get_name().left(2)
			if player_hand[index].get_type() <= Card.CARD_TYPE.HIDDEN and player_hand[index].get_type() >= Card.CARD_TYPE.INVALID:
				card_node.get_node("CenterContainer/Texture").texture = null
			else:
				card_node.get_node("CenterContainer/Texture").texture = cards_textures[player_hand[index].get_type() - 1]
			is_dead = player_hand[index].is_dead()
		else:
			card_node.text = default_card_text
			is_dead = false
		set_card_style(card_node, is_dead)
		index += 1
