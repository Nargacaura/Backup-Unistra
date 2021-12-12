extends Node

export(AudioBusLayout) var bus_layout
export(Array, AudioStream) var button_clicks = []
export(Array, AudioStream) var coin_sounds = []
export(float) var min_master_volume = -24.0
export(float) var min_music_volume = -24.0
export(float) var min_sfx_volume = -24.0

onready var music_player: AudioStreamPlayer = $Music/MusicPlayer
onready var sfx_players: Node = $SFX

enum SFX_PLAYER_OVERRIDE {
	PRIORITY,
	OLDEST,
}

var sfx_player_override: int = SFX_PLAYER_OVERRIDE.PRIORITY
var priorities: Dictionary = {}

var master_bus_index: int
var music_bus_index: int
var sfx_bus_index: int

var music_to_play: AudioStream = null
export(int, 10, 40) var music_fading_rate: int = 20
var fadeout: bool = false


func _ready():
	set_process(false)
	if bus_layout:
		AudioServer.set_bus_layout(bus_layout)
	master_bus_index = AudioServer.get_bus_index("Master")
	music_bus_index = AudioServer.get_bus_index("Music")
	sfx_bus_index = AudioServer.get_bus_index("SFX")
	update_volumes()


func _process(delta):
	# Fade out music
	if music_to_play and fadeout:
		music_player.volume_db -= music_fading_rate * delta
		if music_player.volume_db < -50:
			music_player.stream = music_to_play
			music_player.play()
			fadeout = false
	# Fade in music
	if music_to_play and !fadeout:
		music_player.volume_db += music_fading_rate * delta
		if music_player.volume_db > -18:
			set_process(false)
			music_player.volume_db = -18
			music_to_play = null


func update_volumes() -> void:
	set_master_volume(AppManager.user_settings["sec-volume"]["values"]["master"]["value"])
	set_music_volume(AppManager.user_settings["sec-volume"]["values"]["music"]["value"])
	set_sfx_volume(AppManager.user_settings["sec-volume"]["values"]["sfx"]["value"])


func set_master_volume(volume_percent: int) -> void:
	var volume: float = get_volume_normalized(volume_percent, min_master_volume)
	AudioServer.set_bus_volume_db(master_bus_index, volume)
	AudioServer.set_bus_mute(master_bus_index, volume <= min_master_volume)


func set_music_volume(volume_percent: int) -> void:
	var volume: float = get_volume_normalized(volume_percent, min_music_volume)
	AudioServer.set_bus_volume_db(music_bus_index, volume)
	AudioServer.set_bus_mute(music_bus_index, volume <= min_music_volume)


func set_sfx_volume(volume_percent: int) -> void:
	var volume: float = get_volume_normalized(volume_percent, min_sfx_volume)
	AudioServer.set_bus_volume_db(sfx_bus_index, volume)
	AudioServer.set_bus_mute(sfx_bus_index, volume <= min_sfx_volume)


func get_volume_normalized(volume_percent: int, min_value: float) -> float:
	return -(((volume_percent * min_value) / 100.0) - min_value)


func play_music(music_clip: AudioStream) -> void:
	if music_player.playing:
		music_to_play = music_clip
		fadeout = true
		set_process(true)
	else:
		music_player.stream = music_clip
		music_player.play()


func play_sfx(sfx_clip: AudioStream, priority: int = 0) -> void:
	# Play sfx on a available SFX player
	for sfx_player in sfx_players.get_children():
		if !sfx_player.is_playing():
			sfx_player.stream = sfx_clip
			sfx_player.play()
			priorities[sfx_player.name] = priority
			break
		
		# If all SFX players are taken
		if sfx_player.get_index() == sfx_players.get_child_count() - 1:
			match sfx_player_override:
				SFX_PLAYER_OVERRIDE.PRIORITY:
					var priority_player = check_priority(priorities, priority)
					if priority_player:
						sfx_players.get_node(priority_player).stream = sfx_clip
						sfx_players.get_node(priority_player).play()
						priorities[priority_player] = priority
				
				SFX_PLAYER_OVERRIDE.OLDEST:
					var oldest_player = get_oldest_player()
					if oldest_player:
						oldest_player.stream = sfx_clip
						oldest_player.play()


func check_priority(_priorities: Dictionary, _priority: int):
	var priority_list: Array = []
	var last_priority = null
	
	for key in _priorities:
		if _priority > _priorities[key]:
			priority_list.append(key)
	
	for key in priority_list:
		if !last_priority:
			last_priority = key
			continue
		if _priorities[key] < _priorities[last_priority]:
			last_priority = key
	
	return last_priority


func get_oldest_player() -> AudioStreamPlayer:
	var oldest_player = null
	
	for sfx_player in sfx_players.get_children():
		if !oldest_player:
			oldest_player = sfx_player
			continue
		if sfx_player.get_playback_position() > oldest_player.get_playback_position():
			oldest_player = sfx_player
	
	return oldest_player


func get_random_button_click() -> AudioStream:
	return button_clicks[randi() % button_clicks.size()]


func get_random_coin_sound() -> AudioStream:
	return coin_sounds[randi() % coin_sounds.size()]
