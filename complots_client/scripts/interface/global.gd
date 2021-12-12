extends Control
######################## GLOBAL SINGLETON ######################################

########################### Variables ##########################################
var your_username = "" # shows your username

########################## Server information ##################################
var server_name = "" # The server's name
var password = "" # TODO: hash function 
var players = [] # A list of players from the server
var colors = [ # to differentiate between players on the chatbox.
	"#26d221", # player 1
	"#1f82cf", # player 2
	"#711fcf", # player 3
	"#cf1f3c", # player 4
	"#cf361f", # player 5
	"#cf881f", # player 6
	"#4f4f4e", # player 7
	"#ffffff"  # player 8
	]
var board

############################ Username strings ##################################
# Each one will be delivered here when server gets implemented
var host = ""
var invited_1 = ""
var invited_2 = ""
var invited_3 = ""
var invited_4 = ""
var invited_5 = ""
var invited_6 = ""
var invited_7 = ""

########################## Gameplay status #####################################
var choice = 0 # what's your remaining card choice?
var nb_players = 8 # fetch number of players
var status = [null, null, null, null, null, null, null, null] # who's there?
var roles = [] # Roles for this game
var game_over = 0 # is it over?
var is_dead = 0 # are you dead?
var my_id = 0

########################### Settings ###########################################
var default_sounds = 50 # defaults to 50
var default_language = "en" # defaults to English


