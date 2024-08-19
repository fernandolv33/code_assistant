extends CanvasLayer

@onready var msgbox = $Console/Message
@onready var msgtext = $Console/Message/M/Text


func _ready() -> void:
	hide_msgbox()


func send_message(msg: String):
	msgtext.text = msg
	msgbox.show()
	$Timer.start(10.0)
	

func hide_msgbox():
	AppMaster.console_message.connect(Callable(self, "send_message"))
	msgbox.hide()


func _on_timer_timeout() -> void:
	hide_msgbox()
