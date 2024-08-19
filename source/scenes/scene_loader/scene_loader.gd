extends Control

@onready var actual_scene = $TopMenu
var new_scene: String = ""


func _ready():
	AppMaster.change_scene.connect(Callable(self, "change_scene"))
	AppMaster.emit_signal("console_message", "System boot completed.")


func change_scene(scene_to_load: String = "top_menu/top_menu", update_profile: bool = true):
	$Loader.show()
	new_scene = "res://scenes/%s.tscn" % scene_to_load
	AppMaster.profile["current_scene"] = scene_to_load
	$Timer.start(0.5)
	actual_scene.queue_free()


func _on_timer_timeout():
	actual_scene = load(new_scene).instantiate()
	self.add_child(actual_scene)
	$Loader.hide()
