extends Node
############################## LOBBY ###########################################

########################### Nodes acquired #####################################
# The necessary strings for the server and its players
onready var serv = $lobby/server_name
onready var host = $lobby/lobby_grid/player_list/host
onready var invite_1 = $lobby/lobby_grid/player_list/invited_1
onready var invite_2 = $lobby/lobby_grid/player_list/invited_2
onready var invite_3 = $lobby/lobby_grid/player_list/invited_3
onready var invite_4 = $lobby/lobby_grid/player_list/invited_4
onready var invite_5 = $lobby/lobby_grid/player_list/invited_5
onready var invite_6 = $lobby/lobby_grid/player_list/invited_6
onready var invite_7 = $lobby/lobby_grid/player_list/invited_7
onready var chatlog = $lobby/lobby_grid/Chatbox
onready var role_list = $lobby/lobby_grid/Role_list

var roles_texture = {
	Card.CARD_TYPE.DUKE : preload("res://resources/Icons/icon_duchesse.png"),
	Card.CARD_TYPE.ASSASSIN : preload("res://resources/Icons/icon_assassin.png"),
	Card.CARD_TYPE.CONTESSA : preload("res://resources/Icons/icon_comtesse.png"),
	Card.CARD_TYPE.CAPTAIN : preload("res://resources/Icons/icon_capitaine.png"),
	Card.CARD_TYPE.AMBASSADOR : preload("res://resources/Icons/icon_ambassadeur.png"),
	Card.CARD_TYPE.INQUISITOR : preload("res://resources/Icons/icon_inquisiteur.png")
}
############################### Functions ######################################
# Called when the node enters the scene tree for the first time.
func _ready():
	# Loads the strings of the server & host
	serv.set_text(global.server_name)
	Network.connect_lobby(self)
	update_player_list()
	update_roles()
	# TODO: load already connected invited players


func get_invite_node(index):
	return 	invite_1 if index == 1 else \
			invite_2 if index == 2 else \
			invite_3 if index == 3 else \
			invite_4 if index == 4 else \
			invite_5 if index == 5 else \
			invite_6 if index == 6 else \
			invite_7 if index == 7 else host

func reset_invite():
	host.set_text("Waiting...")
	invite_1.set_text("Waiting...")
	invite_2.set_text("Waiting...")
	invite_3.set_text("Waiting...")
	invite_4.set_text("Waiting...")
	invite_5.set_text("Waiting...")
	invite_6.set_text("Waiting...")
	invite_7 .set_text("Waiting...")

func reset_roles():
	for child in role_list.get_children():
		child.queue_free()

func update_player_list(users = null):
	reset_invite()
	if users != null:
		global.players = users
	for i in range(0,global.players.size()):
		get_invite_node(i).set_text(global.players[i])

func update_roles():
	reset_roles()
	for i in range(0,global.roles.size()):
		var button = TextureButton.new()
		button.set_normal_texture(roles_texture[global.roles[i]])
		role_list.add_child(button)

# Disconnect the user and return to main menu
func _on_disconnect_button_pressed():
	# TODO: Disconnect the user and refresh the display on other users' list
	Network.quit_game()
	if get_tree().change_scene("res://scenes/MainMenu.tscn") != OK:
		print("An error occurred while getting you back to the main menu.")

func _on_play_button_pressed():
	Network.start_game()

func _on_start_game(count):
	global.nb_players = count
	var _s = get_tree().change_scene("res://scenes/Board_scene.tscn")

func _on_player_connected(users):
	update_player_list(users)

func _on_update_chat(username,msg):
	chatlog._update_chat(username,msg)
