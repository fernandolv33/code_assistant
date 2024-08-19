extends HBoxContainer

var my_name: String = ""


func init_item(name: String):
	my_name = name
	$Project.text = my_name


func _on_project_pressed() -> void:
	AppMaster.emit_signal("select_project", my_name)


func _on_delete_me_pressed() -> void:
	AppMaster.todo_data.erase(my_name)
	AppMaster.emit_signal("todo_data_changed")
	AppMaster.emit_signal("todo_project_deleted", my_name)
	self.queue_free()
