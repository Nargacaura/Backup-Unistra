extends Control

export(AudioStream) var background_music = null

onready var main_content: Node = $CenterContainer/MainContent
onready var singleplayer_content: Node = $CenterContainer/SingleplayerContent
onready var multiplayer_content: Node = $CenterContainer/MultiplayerContent
onready var room_settings: Node = $RoomSettings
onready var room_content: Node = $CenterContainer/RoomContent
onready var settings_content: Node = $CenterContainer/SettingsContent
onready var profile_content: Node = $CenterContainer/ProfileContent
onready var rules_content: Node = $CenterContainer/RulesContent
onready var credits_content: Node = $CenterContainer/CreditsContent
onready var login_register: Node = $LoginRegister

var current_content = null setget set_current_content
var _ret # To Stop Warnings


func _ready():
	if background_music:
		AudioManager.play_music(background_music)
	
	current_content = main_content
	settings_content.rules_content = rules_content
	settings_content.credits_content = credits_content
	multiplayer_content.room_content = room_content
	multiplayer_content.room_settings = room_settings
	multiplayer_content.login_register = login_register
	
	display_node(main_content, true)
	display_node(singleplayer_content, false)
	display_node(multiplayer_content, false)
	display_node(room_settings, false)
	display_node(room_content, false)
	display_node(settings_content, false)
	display_node(profile_content, false)
	display_node(rules_content, false)
	display_node(credits_content, false)
	display_node(login_register, false)
	
	_ret = singleplayer_content.connect("back", self, "_on_back")
	_ret = multiplayer_content.connect("back", self, "_on_back")
	_ret = room_content.connect("back", self, "_on_back")
	_ret = settings_content.connect("back", self, "_on_back")
	_ret = profile_content.connect("back", self, "_on_back")
	_ret = rules_content.connect("back", self, "_on_back")
	_ret = credits_content.connect("back", self, "_on_back")
	
	_ret = main_content.singleplayer_btn.connect("pressed", self, "_on_change_content", [singleplayer_content])
	_ret = main_content.multiplayer_btn.connect("pressed", self, "_on_change_content", [multiplayer_content])
	_ret = main_content.settings_btn.connect("pressed", self, "_on_change_content", [settings_content])
	_ret = main_content.profile_btn.connect("pressed", self, "_on_change_content", [profile_content])

	_ret = multiplayer_content.room_settings.connect("create_room_validated", multiplayer_content, "_on_create_room_validated")
	_ret = multiplayer_content.connect("connected_lobby", self, "_on_change_content", [room_content])
	_ret = room_content.settings_btn.connect("pressed", self, "_on_change_content", [settings_content])

	_ret = login_register.connect("logged_in", self, "_on_logged_in")


func _on_logged_in() -> void:
	login_register.hide()
	login_register.set_process(true)


func _on_back(previous_content, _node) -> void:
	if !previous_content:
		return
	set_current_content(previous_content)


func set_current_content(content) -> void:
	if current_content:
		if !content.previous_content:
			content.previous_content = current_content
		current_content.hide_menu()
	if content == main_content:
		reset_content_previous_content()
	current_content = content
	current_content.show_menu()


func reset_content_previous_content() -> void:
		singleplayer_content.previous_content = null
		multiplayer_content.previous_content = null
		room_content.previous_content = null
		settings_content.previous_content = null
		profile_content.previous_content = null
		rules_content.previous_content = null
		credits_content.previous_content = null


func _on_change_content(content) -> void:
	AudioManager.play_sfx(AudioManager.get_random_button_click())
	set_current_content(content)


func display_node(node: Node, status: bool) -> void:
	node.set_process(status)
	if status:
		node.show()
	else:
		node.hide()
