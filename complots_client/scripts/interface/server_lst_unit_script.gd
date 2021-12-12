extends GridContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var lst_srv: Array
var count: int
# Called when the node enters the scene tree for the first time.
func _ready():
	count = 0

func add_server(id,data):
	var creator = data["creator"]
	var server_name = data["name"]
	var count_player = data["count"]
	
	lst_srv.append({})
	lst_srv[count]["creator"] = Label.new()
	lst_srv[count]["creator"].set_text(server_name)
	lst_srv[count]["name"] = Label.new()
	lst_srv[count]["name"].set_text(creator)
	lst_srv[count]["count"] = Label.new()
	lst_srv[count]["count"].align = 1
	lst_srv[count]["count"].set_text(str(count_player)+"/8")
	lst_srv[count]["join"] = Button.new()
	lst_srv[count]["join"].set_text("Join")
	lst_srv[count]["join"].connect("pressed",self,"_on_join_server",[id])
	
	add_child(lst_srv[count]["creator"])
	add_child(lst_srv[count]["name"])
	add_child(lst_srv[count]["count"])
	add_child(lst_srv[count]["join"])
	count += 1


func remove_server(id):
	remove_child(lst_srv[id]["creator"])
	remove_child(lst_srv[id]["name"])
	remove_child(lst_srv[id]["count"])
	remove_child(lst_srv[id]["join"])
	
	lst_srv[id]["join"].disconnect("pressed",self,"_on_join_server")

	lst_srv[id]["creator"].queue_free()
	lst_srv[id]["name"].queue_free()
	lst_srv[id]["count"].queue_free()
	lst_srv[id]["join"].queue_free()
	
	lst_srv.remove(id)
	
	count -=1

func add_list(data):
	clear_all()
	for key in data:
		add_server(key,data[key])

func clear_all():
	for i in count:
		remove_server(lst_srv.size()-1)
	count = 0

func _on_join_server(id):
	Network.join_game(int(id))
