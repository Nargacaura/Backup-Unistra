extends ScrollContainer

signal back(previous_content, node_self)
onready var back_btn: Button = $CenterContainer/Content/PageTitle/Button
var previous_content = null

onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready():
	var _ret = get_tree().get_root().connect("size_changed", self, "_on_window_resize")
	_ret = back_btn.connect("pressed", self, "_on_Back_pressed")
	_on_window_resize()


func _on_window_resize() -> void:
	if get_viewport_rect().size[0] > get_viewport_rect().size[1]:
		rect_min_size[1] = 920
		$CenterContainer/Content/PageContent/Characters/SectionGrid.columns = 3
	else:
		rect_min_size[1] = 1320
		$CenterContainer/Content/PageContent/Characters/SectionGrid.columns = 2


func hide_menu() -> void:
	animation_player.play("hide")
	set_process(false)


func show_menu() -> void:
	set_process(true)
	animation_player.play("show")


func _on_Back_pressed() -> void:
	AudioManager.play_sfx(AudioManager.get_random_button_click())
	emit_signal("back", previous_content, self)
