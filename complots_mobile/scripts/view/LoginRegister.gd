extends ColorRect

signal logged_in()
signal log_updated(success)

onready var buttons_container: Node = $CenterContainer/Panel/Content/Header
onready var login_btn: Button = $CenterContainer/Panel/Content/Header/Login
onready var register_btn: Button = $CenterContainer/Panel/Content/Header/Register

onready var login_validate_btn: Button = $CenterContainer/Panel/Content/Pages/LoginPage/Connect/Button
onready var register_validate_btn: Button = $CenterContainer/Panel/Content/Pages/RegisterPage/Create/Button

onready var pages_container: Node = $CenterContainer/Panel/Content/Pages
onready var login_page: Node = $CenterContainer/Panel/Content/Pages/LoginPage
onready var register_page: Node = $CenterContainer/Panel/Content/Pages/RegisterPage

onready var login_username: LineEdit = $CenterContainer/Panel/Content/Pages/LoginPage/Username/LineEdit
onready var login_password: LineEdit = $CenterContainer/Panel/Content/Pages/LoginPage/Password/LineEdit
onready var login_error: Label = $CenterContainer/Panel/Content/Pages/LoginPage/Error
onready var login_continue_no_login: Button = $CenterContainer/Panel/Content/Pages/LoginPage/ContinueNoLogin

onready var register_username: LineEdit = $CenterContainer/Panel/Content/Pages/RegisterPage/Username/LineEdit
onready var register_password: LineEdit = $CenterContainer/Panel/Content/Pages/RegisterPage/Password/LineEdit
onready var register_confirmation: LineEdit = $CenterContainer/Panel/Content/Pages/RegisterPage/Confirmation/LineEdit
onready var register_error: Label = $CenterContainer/Panel/Content/Pages/RegisterPage/Error
onready var register_continue_no_login: Button = $CenterContainer/Panel/Content/Pages/RegisterPage/ContinueNoLogin


enum PAGE {
	LOGIN = 0,
	REGISTER = 1
}

var current_page_index: int = PAGE.LOGIN


func _ready():
	update_pages()
	
	var _ret = login_btn.connect("pressed", self, "_on_change_page", [PAGE.LOGIN])
	_ret = register_btn.connect("pressed", self, "_on_change_page", [PAGE.REGISTER])
	_ret = login_validate_btn.connect("pressed", self, "_on_login_validate")
	_ret = register_validate_btn.connect("pressed", self, "_on_register_validate")
	_ret = login_continue_no_login.connect("pressed", self, "_on_continue_no_login")
	_ret = register_continue_no_login.connect("pressed", self, "_on_continue_no_login")
	_ret = Network.connect("update_log", self, "_on_update_log")
	
	_ret = login_continue_no_login.connect("mouse_entered", self, "_on_continue_no_login_entered", [login_continue_no_login])
	_ret = register_continue_no_login.connect("mouse_entered", self, "_on_continue_no_login_entered", [register_continue_no_login])
	_ret = login_continue_no_login.connect("mouse_exited", self, "_on_continue_no_login_exited", [login_continue_no_login])
	_ret = register_continue_no_login.connect("mouse_exited", self, "_on_continue_no_login_exited", [register_continue_no_login])
	
	_ret = login_username.connect("text_entered", self, "_on_login_validate_enter")
	_ret = login_password.connect("text_entered", self, "_on_login_validate_enter")
	_ret = register_username.connect("text_entered", self, "_on_register_validate_enter")
	_ret = register_password.connect("text_entered", self, "_on_register_validate_enter")
	_ret = register_confirmation.connect("text_entered", self, "_on_register_validate_enter")


func display_node(node: Node) -> void:
	node.show()
	node.set_process(true)


func hide_node(node: Node) -> void:
	node.hide()
	node.set_process(false)


func _on_continue_no_login() -> void:
	logged_in()


func _on_continue_no_login_entered(button: Button) -> void:
	button.self_modulate = Color("#999999")


func _on_continue_no_login_exited(button: Button) -> void:
	button.self_modulate = Color(1, 1, 1)


func _on_update_log(result, username) -> void:
	if !self.visible:
		emit_signal("log_updated", false)
		return
	
	var is_logged: bool = false
	if !result and username == null:
		pages_container.get_child(current_page_index).get_node("Error").text = Localization.get("menu.error.connection_failed")
	elif !result and username:
		pages_container.get_child(current_page_index).get_node("Error").text = Localization.get("menu.error.invalid_log")
	else:
		AppManager.set_username(username)
		AppManager.save_user_data()
		is_logged = true
	
	emit_signal("log_updated", is_logged)

func _on_change_page(page_index: int) -> void:
	AudioManager.play_sfx(AudioManager.get_random_button_click())
	
	if page_index < PAGE.LOGIN: page_index = PAGE.LOGIN
	if page_index > PAGE.REGISTER: page_index = PAGE.REGISTER
	
	if current_page_index != page_index:
		clear_input_fields()
	current_page_index = page_index
	
	update_pages()
	update_buttons()


func _on_login_validate_enter(_text: String) -> void:
	_on_login_validate()


func _on_register_validate_enter(_text: String) -> void:
	_on_register_validate()


func _on_login_validate() -> void:
	AudioManager.play_sfx(AudioManager.get_random_button_click())
	var username: String = login_username.text
	var password: String = login_password.text
	
	if username == "":
		login_error.text = Localization.get("menu.login_empty")
		return
	if password == "":
		login_error.text = Localization.get("menu.password_empty")
		return
	login_error.text = ""
	
	Network.connect_login(username, password)
	var success = yield(self, "log_updated")
	if success:
		logged_in()


func _on_register_validate() -> void:
	AudioManager.play_sfx(AudioManager.get_random_button_click())
	var username: String = register_username.text
	var password: String = register_password.text
	var confirmation: String = register_confirmation.text
	
	if username == "":
		register_error.text = Localization.get("menu.login_empty")
		return
	if password == "":
		register_error.text = Localization.get("menu.password_empty")
		return
	if confirmation == "":
		register_error.text = Localization.get("menu.confirmation_empty")
		return
	if password != confirmation:
		register_error.text = Localization.get("menu.password_confirmation_no_match")
		return
	register_error.text = ""
	
	Network.create_login(username, password, username)
	var success = yield(self, "log_updated")
	if success:
		logged_in()


func logged_in() -> void:
	clear_input_fields()
	emit_signal("logged_in")


func clear_input_fields() -> void:
	login_username.text = ""
	login_password.text = ""
	register_username.text = ""
	register_password.text = ""
	register_confirmation.text = ""


func update_pages() -> void:
	display_node(pages_container.get_child(current_page_index))
	hide_node(pages_container.get_child((current_page_index + 1) % 2))


func update_buttons() -> void:
	buttons_container.get_child(current_page_index).pressed = true
	buttons_container.get_child((current_page_index + 1) % 2).pressed = false
