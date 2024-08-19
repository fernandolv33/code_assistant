extends Button


@export var button_label: String = ""
@export var menu_event: int = 0


func _ready():
	self.text = button_label
	get_tree().get_root().size_changed.connect(Callable(self, "resize_me"))


func _on_pressed():
	AppMaster.emit_signal("top_menu_event", menu_event)
