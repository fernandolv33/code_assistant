extends Button


func _ready() -> void:
	self.disabled = true
	AppMaster.todo_data_changed.connect(Callable(self, "data_changed"))
	AppMaster.data_saved.connect(Callable(self, "data_saved"))


func _on_pressed() -> void:
	AppMaster.save_todo()
	self.disabled = true


func data_changed():
	self.disabled = false

func data_saved():
	self.disabled = true
