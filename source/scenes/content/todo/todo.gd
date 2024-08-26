extends MarginContainer

@onready var projects = $Content/Projects
@onready var project_list = $Content/Projects/S/Project

@onready var new_project = $Content/Projects/AddProject/NewProject

@onready var project_name = $Content/Tasks/Header/ProjectName
@onready var tasks = $Content/Tasks
@onready var task_list = $Content/Tasks/S/TodoList

@onready var new_task = $Content/Tasks/AddTask/NewTask

@onready var save_button = $Content/Projects/Header/Save

var project_item = preload("res://scenes/content/todo/project_item.tscn")
var task_item = preload("res://scenes/content/todo/todo_item.tscn")

var selected_project: String = ""

func _ready() -> void:
	AppMaster.select_project.connect(Callable(self, "select_project"))
	AppMaster.todo_project_deleted.connect(Callable(self, "check_project"))
	load_data()


func load_data():
	tasks.hide()
	for i in project_list.get_children():
		i.queue_free()

	if not AppMaster.load_todo():
		return

	if AppMaster.todo_data.size() == 0:
		AppMaster.emit_signal("console_message", "No project available. Please create a new project.")
		return

	for i in AppMaster.todo_data:
		var ii = project_item.instantiate()
		project_list.add_child(ii)
		ii.init_item(i)

	AppMaster.emit_signal("console_message", "Select a project.")


func _on_add_project_pressed() -> void:
	if new_project.text == "":
		return
	if new_project.text in AppMaster.todo_data:
		return

	var ii = project_item.instantiate()
	project_list.add_child(ii)
	ii.init_item(new_project.text)
	AppMaster.todo_data[new_project.text] = []
	AppMaster.save_todo()
	new_project.text = ""


func select_project(project: String):
	selected_project = project
	project_name.text = selected_project
	for i in task_list.get_children():
		i.queue_free()
	var index_item: int = 0
	for i in AppMaster.todo_data[selected_project]:
		var ii = task_item.instantiate()
		task_list.add_child(ii)
		ii.init_item(selected_project, index_item, i)
		index_item += 1
	tasks.show()


func _on_add_task_pressed() -> void:
	if new_task.text == "":
		return
	var new_key = AppMaster.get_random_key()
	var dd = {"task": new_task.text, "done": false}
	var item_index = AppMaster.todo_data[selected_project].size()
	AppMaster.todo_data[selected_project].append(dd)
	var ii = task_item.instantiate()
	task_list.add_child(ii)
	ii.init_item(selected_project, item_index, dd)
	new_task.text = ""
	AppMaster.save_todo()


func check_project(project: String):
	if selected_project == project:
		tasks.hide()
