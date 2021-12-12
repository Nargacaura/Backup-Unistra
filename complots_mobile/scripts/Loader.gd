extends Control

onready var resource_queue = preload("res://scripts/misc/resource_queue.gd").new()

enum LoadingStates {
	FADE_TO_LOADING,
	LOADING,
	FADE_TO_SCREEN,
	PLAYING
}

var root = null
var loading_state = LoadingStates.PLAYING
var current_scene = null
var loading_scene = null

var _ret # To Stop Warnings


func _ready():
	resource_queue.start()
	root = get_tree().get_root()
	_ret = LoadingScreen.connect("finished_fading", self, "_on_LoadingScreen_finished_fading")
	current_scene = root.get_child(root.get_child_count() - 1)


func load_scene(path) -> void:
	loading_scene = path
	current_scene.visible = false
	resource_queue.queue_resource(path)
	loading_state = LoadingStates.FADE_TO_LOADING
	LoadingScreen.is_faded = true

func _on_LoadingScreen_finished_fading() -> void:
	match loading_state:
		LoadingStates.FADE_TO_LOADING:
			current_scene.visible = false
			
			if current_scene:
				current_scene.queue_free()
				current_scene = null
			
			loading_state = LoadingStates.LOADING
			set_process(true)
		LoadingStates.FADE_TO_SCREEN:
			loading_state = LoadingStates.PLAYING
		_:
			pass


func _process(_delta) -> void:
	if loading_state == LoadingStates.LOADING:
		var new_scene = resource_queue.get_resource(loading_scene)
		
		if new_scene:
			current_scene = new_scene.instance()
			loading_state = LoadingStates.FADE_TO_SCREEN
			LoadingScreen.is_faded = false
			root.add_child(current_scene)
			current_scene.visible = true
			set_process(false)
