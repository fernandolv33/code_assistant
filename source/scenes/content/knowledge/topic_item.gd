extends VBoxContainer

@onready var labels = $Header/Labels
@onready var topictext = $Content/Topic
@onready var content = $Content
@onready var expand_button = $Header/Show
@onready var hide_button = $Header/Hide

var myKey: String = ""
var myData ={}
var display_status: int = 0


func _ready() -> void:
	_on_hide_pressed()

	

func init_item(key: String, data):
	myKey = key
	myData = data
	
	labels.text = ""
	for i in myData.labels:
		labels.text += "%s " % i
	topictext.text = myData.text


func _on_show_pressed() -> void:
	content.show()
	hide_button.show()
	expand_button.hide()


func _on_hide_pressed() -> void:
	content.hide()
	hide_button.hide()
	expand_button.show()


func _on_copy_pressed() -> void:
	DisplayServer.clipboard_set(topictext.text)
	AppMaster.emit_signal("console_message", "Copied to clipboard.")


func _on_save_pressed() -> void:
	AppMaster.knowledge_data[myKey].text = topictext.text
	AppMaster.save_knowledge()

func _on_delete_pressed() -> void:
	AppMaster.knowledge_data.erase(myKey)
	AppMaster.save_knowledge()
	self.queue_free()

	pass # Replace with function body.
