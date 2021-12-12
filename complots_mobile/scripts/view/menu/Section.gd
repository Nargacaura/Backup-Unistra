extends VBoxContainer

export(String) var title: String = "Title" setget set_title
onready var title_node: Label = $SectionTitle/Title
onready var section_grid: GridContainer = $SectionGrid

var achievements: Dictionary = {}


func _ready():
	var _ret = get_tree().get_root().connect("size_changed", self, "_on_window_resize")
	_on_window_resize()


func _on_window_resize() -> void:
	if get_viewport_rect().size[0] > get_viewport_rect().size[1]:
		$SectionGrid.columns = 3
	else:
		$SectionGrid.columns = 2


func set_title(_title) -> void:
	title = _title
	title_node.text = _title


func add_item(item: Node, order: int) -> void:
	section_grid.add_child(item)
	achievements[order] = item


func update_orders() -> void:
	for key in achievements:
		section_grid.move_child(achievements[key], key)


func delete() -> void:
	for item in section_grid.get_children():
		item.queue_free()
	achievements = {}
	queue_free()
