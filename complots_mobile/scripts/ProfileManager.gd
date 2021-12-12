extends Control

signal back(previous_content, node_self)
onready var back_btn: Button = $CenterContainer/Content/PageTitle/Button
var previous_content = null

onready var animation_player: AnimationPlayer = $AnimationPlayer

export(Color) var badge_hidden_color: Color = Color("#32000000")
export(Color) var badge_revealed_color: Color = Color("#fbae17")
onready var badges_container: Node = $CenterContainer/Content/Grid/LeftColumn/Profile/Container/Right/BadgesContainer/Grid
onready var username_label: Label = $CenterContainer/Content/Grid/LeftColumn/Profile/Container/Left/Header/ItemTitle/Title
onready var page_content: Node = $CenterContainer/Content/PageContent
var section_scene = preload("res://scenes/menu/items/Section.tscn")
var achievement_scene = preload("res://scenes/menu/items/Achievement.tscn")

var user_data: Dictionary = {}
var sections: Dictionary = {}
var _ret # To Stop Warnings


func _ready():
	_ret = get_tree().get_root().connect("size_changed", self, "_on_window_resize")
	_ret = back_btn.connect("pressed", self, "_on_Back_pressed")
	_ret = AppManager.connect("update_user_data", self, "_on_user_data_updated")
	user_data = AppManager.user_data
	init_page()
	_on_window_resize()


func _on_window_resize() -> void:
	if get_viewport_rect().size[0] > get_viewport_rect().size[1]:
		rect_min_size[1] = 920
	else:
		rect_min_size[1] = 1320


func hide_menu() -> void:
	animation_player.play("hide")
	set_process(false)


func show_menu() -> void:
	update_page()
	set_process(true)
	animation_player.play("show")


func _on_Back_pressed() -> void:
	AudioManager.play_sfx(AudioManager.get_random_button_click())
	emit_signal("back", previous_content, self)


func init_page() -> void:
	for section in user_data:
		if section == "game-config":
			continue
		if section == "login":
			username_label.text = user_data["login"]["username"]
			continue
		
		var section_title: String = Localization.get(user_data[section]["title"])
		var values: Dictionary = user_data[section]["values"]
		
		# Creation of the section node
		var section_to_add = section_scene.instance()
		section_to_add.name = section
		page_content.add_child(section_to_add)
		sections[user_data[section]["order"]] = section_to_add
		section_to_add.title = section_title
		
		for item in values:
			var item_title: String = Localization.get(values[item]["title"])
			var item_desc = Localization.get(values[item]["desc"])
			var value = values[item]["value"]
			var order = values[item]["order"]
			
			create_item(item_title, item_desc, value, order, section_to_add)
		
		section_to_add.update_orders()
	update_orders()
	update_badges()
	_on_window_resize()


func create_item(title: String, desc: String, value, order: int, container) -> void:
	var achievement = achievement_scene.instance()
	container.add_item(achievement, order)
	achievement.title = title
	achievement.text = desc % [value[1]]
	achievement.current_amount = value[0]
	achievement.max_amount = value[1]


func update_orders() -> void:
	for key in sections:
		page_content.move_child(sections[key], key)


func update_badges() -> void:
	# Update characters badges
	var validated_all: bool = true
	var characters_achievements = AppManager.user_data["sec-character-achievements"]["values"]
	for key in characters_achievements:
		if characters_achievements[key]["value"][0] >= characters_achievements[key]["value"][1]:
			badges_container.get_node("%s/TextureRect" % [key]).modulate = badge_revealed_color
		else:
			badges_container.get_node("%s/TextureRect" % [key]).modulate = badge_hidden_color
			validated_all = false
	
	if !validated_all:
		badges_container.get_node("Achievements/TextureRect").modulate = badge_hidden_color
		return
	
	# Update achievements badge
	var achievements = AppManager.user_data["sec-character-achievements"]["values"]
	for key in achievements:
		if achievements[key]["value"][0] < achievements[key]["value"][1]:
			validated_all = false
			break
	
	if validated_all:
		badges_container.get_node("Achievements/TextureRect").modulate = badge_revealed_color
	else:
		badges_container.get_node("Achievements/TextureRect").modulate = badge_hidden_color


func clear_page() -> void:
	for section in page_content.get_children():
		section.delete()
	sections = {}


func update_page() -> void:
	clear_page()
	init_page()


func _on_user_data_updated(data: Dictionary) -> void:
	user_data = data
	update_page()
