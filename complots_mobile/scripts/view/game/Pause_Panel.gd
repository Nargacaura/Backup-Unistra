extends Control

onready var label: Label = $Border/Background/VBoxContainer/Label
onready var continue_btn: Button = $Border/Background/VBoxContainer/ContinueContainer/Continue
onready var main_menu_btn: Button = $Border/Background/VBoxContainer/MainMenuContainer/MainMenu

var paused: bool = false
var _ret # To Stop warnings


func _ready():
	_ret = continue_btn.connect("pressed", self, "_on_Continue_pressed")
	_ret = main_menu_btn.connect("pressed", self, "_on_MainMenu_pressed")


func toggle_pause() -> void:
	if AppManager.is_singleplayer:
		get_tree().paused = !get_tree().paused
		paused = get_tree().paused
	else:
		paused = !paused
	
	if paused:
		show()
		set_process(true)
	else:
		hide()
		set_process(false)


func _on_Continue_pressed() -> void:
	AudioManager.play_sfx(AudioManager.get_random_button_click())
	toggle_pause()


func _on_MainMenu_pressed() -> void:
	AudioManager.play_sfx(AudioManager.get_random_button_click())
	if !AppManager.is_singleplayer:
		Network.quit_game()
	get_tree().paused = false
	Loader.load_scene(AppManager.main_menu)


func set_text(text: String) -> void:
	label.text = text


func hide_continue() -> void:
	continue_btn.hide()
	continue_btn.set_process(false)
