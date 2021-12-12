extends PopupDialog
####################### GAME OVER POPUP DIALOG #################################

########################### Nodes acquired #####################################
onready var winner = $HBoxContainer/winner_username # Winner's username
onready var timer = $LobbyTimer # Timer before getting back to the lobby
onready var disconnect_button = $HBoxContainer/VBoxContainer/MenuButton # Disconnect button

############################### Functions ######################################
# Called when the node enters the scene tree for the first time.
# Showcases the winner and starts the timer
func _ready():
	winner.set_text(">winner goes here<")

func set_winner_name(name):
	winner.set_text(name)

func start_timer():
	timer.start(10)

# Disconnects the user and gets them back to the main menu
func _on_MenuButton_pressed():
	Network.quit_game()
	hide()
	if get_tree().change_scene("res://scenes/MainMenu.tscn") != OK:
		print("An error occurred while getting you back to the main menu.")

# On timeout, get all users who stayed logged in back to the lobby
func _on_LobbyTimer_timeout():
	hide()
	get_tree().change_scene("res://scenes/Lobby.tscn")
