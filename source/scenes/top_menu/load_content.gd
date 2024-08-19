extends Control

const APPS = [
	preload("res://scenes/content/home/home.tscn"),
	preload("res://scenes/content/todo/todo.tscn"),
	preload("res://scenes/content/knowledge/knowledge.tscn")
]



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AppMaster.top_menu_event.connect(Callable(self, "load_content"))
	load_content(0)



func load_content(content: int):
	if content == 9:
		get_tree().quit()
		return

	for i in self.get_children():
		i.queue_free()
		
	var ii = APPS[content].instantiate()
	self.add_child(ii)
