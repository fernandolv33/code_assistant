extends HBoxContainer

var myProject: String = ""
var myKey: int
var myData = {}

const STATUS_COLOR = ["ffffff", "444444"]

@onready var item_text = $ToDo
@onready var item_edit = $ToDoEdit
@onready var button_edit = $Edit
@onready var button_save = $Save
@onready var button_cancel = $Cancel
@onready var button_up = $Up
@onready var button_down = $Down
@onready var button_delete = $Delete

@onready var edit_text = $ToDoEdit

var item_initialized: bool = false

func _ready() -> void:
	hide_edit()


func init_item(project: String, key: int, data):
	myProject = project
	myKey = key
	myData = data
	$ToDo.text = myData.task
	$Done.button_pressed = myData.done
	set_color()
	item_initialized = true


func _on_delete_pressed() -> void:
	AppMaster.todo_data[myProject].pop_at(myKey)
	AppMaster.emit_signal("todo_data_changed")
	AppMaster.emit_signal("select_project", myProject)
	self.queue_free()


func _on_done_toggled(toggled_on: bool) -> void:
	AppMaster.todo_data[myProject][myKey].done = toggled_on
	myData.done = toggled_on
	set_color()
	if item_initialized:
		AppMaster.emit_signal("todo_data_changed")


func set_color():
	if myData.done:
		$ToDo.modulate = STATUS_COLOR[1]
	else:
		$ToDo.modulate = STATUS_COLOR[0]


func _on_edit_pressed() -> void:
	edit_text.text = myData.task
	show_edit()


func _on_save_pressed() -> void:
	myData.task = edit_text.text
	$ToDo.text = myData.task
	hide_edit()
	AppMaster.save_todo()


func _on_cancel_pressed() -> void:
	hide_edit()


func hide_edit():
	item_text.show()
	item_edit.hide()
	button_edit.show()
	button_save.hide()
	button_cancel.hide()
	button_up.hide()
	button_down.hide()
	button_delete.show()

func show_edit():
	item_text.hide()
	item_edit.show()
	button_edit.hide()
	button_save.show()
	button_cancel.show()
	button_up.hide()
	button_down.hide()
	button_delete.hide()
