extends VBoxContainer

@onready var answer = $H/Answer


func init_item(key: String, ratio: float):
	$Ratio.text = "%.3f" % ratio
	answer.text = AppMaster.knowledge_data[key].text

func _on_copy_pressed() -> void:
	DisplayServer.clipboard_set(answer.text)
	AppMaster.emit_signal("console_message", "Content copied to clipboard.")
