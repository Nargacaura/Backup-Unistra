extends Node

const SQLite := preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
const db_path := "res://data.db"
const users_table := "Users"
const scores_table := "Scores"
var db = null # Idk its type

const users_dict := {
	"id_user": {"data_type":"int", "primary_key": true, "not_null": true, "autoincrement": true},
	"login": {"data_type":"text", "not_null": true, "unique": true},
	"passwd": {"data_type":"text", "not_null": true},
	"username": {"data_type": "text"},
	"mail": {"data_type": "text"}
	}
const users_query := "CREATE TABLE IF NOT EXISTS Users (id_user INTEGER PRIMARY KEY NOT NULL,login text NOT NULL UNIQUE,passwd text NOT NULL,username text,mail text);"

const scores_dict := {
	"id_score": {"data_type":"int", "primary_key": true, "not_null": true, "autoincrement": true},
	"id_user": {"data_type":"int", "foreign_key": users_table + ".id_user", "not_null":true},
	"wins": {"data_type":"int", "default": 0},
	"total": {"data_type":"int", "default": 0}
}
const scores_query := "CREATE TABLE IF NOT EXISTS Scores (id_score INTEGER PRIMARY KEY NOT NULL,id_user INTEGER NOT NULL, wins INTEGER DEFAULT 0, total INTEGER DEFAULT 0, FOREIGN KEY (id_user) REFERENCES Users(id_user));"

func _ready():
	var _s
	open_tables_db()
	create_tables()
#	print(insert_user('ijij', 'test'))
#	print(insert_user('ijij', 'test'))
#	print("2 = ", check_user('ijij', 'ui'))
#	print("1 = ", check_user('ijij', 'test'))
#	print("0 = ", check_user('salut', 'ui'))
#	_s = update_score('ijij', 20)
#	_s = update_score('ijij', 20)
#	_s = update_wins('ijij')


func open_tables_db() -> void:
	db = SQLite.new()
	db.path = db_path
	db.verbose_mode = true # must be turned off for production server
	db.foreign_keys = true
	db.open_db()


func create_tables() -> void:
	db.query(users_query)
	db.query(scores_query)
#	db.create_table(users_table, users_dict)
#	db.create_table(scores_table, scores_dict)

# Return:
# - true: user correctly inserted
# - false: user already exists
func insert_user(login: String, passwd: String, username: String) -> bool:
	var res: bool
	var select_res: Array
	var cond_str := "login == " + '"' + login + '"'
	res = db.insert_row(users_table, {"login": login, "passwd":passwd,"username":username})
	if res == false:
		return false	# user already registered
	select_res = db.select_rows(users_table, cond_str, ["id_user"])
	res = db.insert_row(scores_table, {"id_user": select_res[0].id_user})
	return res	# won't be false
	

# Return values:
# - 0: Unregistered user
# - 1: good login, good password
# - 2: wrong password
func check_user(login: String, passwd: String) -> Array:
	var select_res: Array
	var string_cond := "login == " + '"' + login + '"'
	select_res = db.select_rows(users_table, string_cond, ["login", "passwd","username"])
	if select_res.size() == 0:
		return [] # user not in database
	elif select_res[0].passwd == passwd:
		return select_res# user in database and correct passwd
	else:
		return [] # incorrect passwd


# This function assume login already exists
# It adds up total (parameter) to the total field
func _update_score(login: String, total: int) -> bool:
	var select_res: Array
	var _res: bool
	var cur_total: int
	var cond_str := "login == " + '"' + login + '"'
	select_res = db.select_rows(users_table, cond_str, ["id_user"])
	cond_str = "id_user == " + '"' + str(select_res[0].id_user) + '"'
	select_res = db.select_rows(scores_table, cond_str, ["total"])
	cur_total = select_res[0].total + total
	return db.update_rows(scores_table, cond_str, {"total": cur_total})

# This function assume login already exists
# It only increments wins
func _update_wins(login: String) -> bool:
	var select_res: Array
	var _res: bool
	var cur_wins: int
	var cond_str := "login == " + '"' + login + '"'
	select_res = db.select_rows(users_table, cond_str, ["id_user"])
	cond_str = "id_user == " + '"' + str(select_res[0].id_user) + '"'
	select_res = db.select_rows(scores_table, cond_str, ["wins"])
	cur_wins = select_res[0].wins + 1
	return db.update_rows(scores_table, cond_str, {"wins": cur_wins})
