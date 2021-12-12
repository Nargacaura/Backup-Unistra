extends VBoxContainer

onready var animation_player: AnimationPlayer = $AnimationPlayer

onready var username_btn: Button = $Grid/Bottom/Username/Button
onready var quit_btn: Button = $PageTitle/Button

onready var multiplayer_btn: Button = $Grid/Top/LeftColumn/Multiplayer/Button
onready var singleplayer_btn: Button = $Grid/Top/CenterColumn/Singleplayer/Button
onready var settings_btn: Button = $Grid/Top/CenterColumn/Settings/Button
onready var profile_btn: Button = $Grid/Bottom/Profile/Button
var previous_content = null


func _ready():
	if !AppManager.COMPUTER_BUILD:
		quit_btn.hide()
		quit_btn.set_process(false)
	username_btn.text = AppManager.user_data["login"]["username"]
	var _ret = get_tree().get_root().connect("size_changed", self, "_on_window_resize")
	_ret = quit_btn.connect("pressed", self, "_on_Quit_pressed")
	_ret = AppManager.connect("update_user_data", self, "_on_user_data_updated")
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


func _on_Quit_pressed() -> void:
	# TODO: Clean Up application
	get_tree().quit()


func _on_user_data_updated(data: Dictionary) -> void:
	username_btn.text = data["login"]["username"]
