extends VBoxContainer

signal back(previous_content, node_self)
onready var back_btn: Button = $PageTitle/Button
var previous_content = null

onready var animation_player: AnimationPlayer = $AnimationPlayer

onready var volume_master: Node = $Grid/Top/LeftColumn/Volume/Content/ContentContainer/Master/Container
onready var volume_music: Node = $Grid/Top/LeftColumn/Volume/Content/ContentContainer/Music/Container
onready var volume_sfx: Node = $Grid/Top/LeftColumn/Volume/Content/ContentContainer/SFX/Container
onready var language_label: Label = $Grid/Bottom/Language/Content/ItemContainer/Label

onready var rules_btn: Button = $Grid/Top/CenterColumn/Rules/Button
onready var credits_btn: Button = $Grid/Top/CenterColumn/Credits/Button
onready var lang_btn: Button = $Grid/Bottom/Language/Button
onready var save_btn: Button = $Grid/Bottom/Save/Button
onready var save_text_btn: Button = $Grid/Bottom/Save/SaveText

var settings: Dictionary = {}
var rules_content = null
var credits_content = null
var _ret # To Stop Warnings


func _ready():
	_ret = get_tree().get_root().connect("size_changed", self, "_on_window_resize")
	settings = AppManager.user_settings
	_ret = back_btn.connect("pressed", self, "_on_Back_pressed")
	
	_ret = volume_master.get_node("HSlider").connect("value_changed", self, "_on_Volume_value_changed", ["master"])
	_ret = volume_music.get_node("HSlider").connect("value_changed", self, "_on_Volume_value_changed", ["music"])
	_ret = volume_sfx.get_node("HSlider").connect("value_changed", self, "_on_Volume_value_changed", ["sfx"])
	
	_ret = rules_btn.connect("pressed", self, "_on_RulesBtn_pressed")
	_ret = credits_btn.connect("pressed", self, "_on_CreditsBtn_pressed")
	_ret = lang_btn.connect("pressed", self, "_on_LangBtn_pressed")
	_ret = save_btn.connect("pressed", self, "_on_SaveBtn_pressed")
	_ret = save_btn.connect("mouse_entered", self, "_on_SaveBtn_hover", [true])
	_ret = save_btn.connect("mouse_exited", self, "_on_SaveBtn_hover", [false])
	_ret = save_text_btn.connect("pressed", self, "_on_SaveBtn_pressed")
	
	init_page()
	_on_window_resize()


func _on_window_resize() -> void:
	if get_viewport_rect().size[0] > get_viewport_rect().size[1]:
		$Grid.columns = 2
		$Grid/Bottom.columns = 1
	else:
		$Grid.columns = 1
		$Grid/Bottom.columns = 2


func hide_menu() -> void:
	animation_player.play("hide")
	set_process(false)


func show_menu() -> void:
	set_process(true)
	animation_player.play("show")


func _on_Back_pressed() -> void:
	AudioManager.play_sfx(AudioManager.get_random_button_click())
	emit_signal("back", previous_content, self)


func _on_SaveBtn_pressed() -> void:
	AudioManager.play_sfx(AudioManager.get_random_button_click())
	AppManager.save_user_settings()


func _on_SaveBtn_hover(is_hover: bool) -> void:
	if is_hover:
		save_btn.get_parent().modulate = Color(0.6, 0.6, 0.6)
	else:
		save_btn.get_parent().modulate = Color(1, 1, 1)


func _on_RulesBtn_pressed() -> void:
	AudioManager.play_sfx(AudioManager.get_random_button_click())
	emit_signal("back", rules_content, self)


func _on_CreditsBtn_pressed() -> void:
	AudioManager.play_sfx(AudioManager.get_random_button_click())
	emit_signal("back", credits_content, self)


func init_page() -> void:
	# Init Volume
	update_volumes()
	
	# Init Language
	update_lang()


func update_volumes() -> void:
	volume_master.get_node("Text/Volume").text = str(settings["sec-volume"]["values"]["master"]["value"])
	volume_music.get_node("Text/Volume").text = str(settings["sec-volume"]["values"]["music"]["value"])
	volume_sfx.get_node("Text/Volume").text = str(settings["sec-volume"]["values"]["sfx"]["value"])
	
	volume_master.get_node("HSlider").value = settings["sec-volume"]["values"]["master"]["value"]
	volume_music.get_node("HSlider").value = settings["sec-volume"]["values"]["music"]["value"]
	volume_sfx.get_node("HSlider").value = settings["sec-volume"]["values"]["sfx"]["value"]


func _on_Volume_value_changed(value: float, property: String) -> void:
	match property:
		"master":
			AppManager.user_settings["sec-volume"]["values"]["master"]["value"] = int(value)
			volume_master.get_node("Text/Volume").text = str(value)
			volume_master.get_node("HSlider").value = value
		"music":
			AppManager.user_settings["sec-volume"]["values"]["music"]["value"] = int(value)
			volume_music.get_node("Text/Volume").text = str(value)
			volume_music.get_node("HSlider").value = value
		"sfx":
			AppManager.user_settings["sec-volume"]["values"]["sfx"]["value"] = int(value)
			volume_sfx.get_node("Text/Volume").text = str(value)
			volume_sfx.get_node("HSlider").value = value
		_:
			pass
	AppManager.save_user_settings()
	AudioManager.update_volumes()


func _on_LangBtn_pressed() -> void:
	AudioManager.play_sfx(AudioManager.get_random_button_click())
	Localization.lang = Localization.lang + 1
	update_lang()


func update_lang() -> void:
	language_label.text = get_lang_pretty(Localization.lang)


func get_lang_pretty(lang: int) -> String:
	match lang:
		Localization.LANG.en_US: return "ENGLISH"
		Localization.LANG.fr_FR: return "FRENCH"
		_: return ""
