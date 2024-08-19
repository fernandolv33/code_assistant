extends MarginContainer

@onready var topic_list = $Columns/Database/S/List

@onready var newtopic_labels = $Columns/AddTopic/NewLabels
@onready var newtopic_text = $Columns/AddTopic/NewTopic

var topic_item = preload("res://scenes/content/knowledge/topic_item.tscn")


func _ready() -> void:
	load_data()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if newtopic_labels.has_focus():
			if newtopic_labels.text != "":
				newtopic_text.grab_focus()
		elif newtopic_text.has_focus():
			if newtopic_text.text != "":
				_on_add_topic_pressed()


func load_data():
	for i in topic_list.get_children():
		i.queue_free()

	if not AppMaster.load_knowledge():
		return

	for i in AppMaster.knowledge_data:
		add_item(i)


func add_item(key: String):
	var ii = topic_item.instantiate()
	topic_list.add_child(ii)
	ii.init_item(key, AppMaster.knowledge_data[key])


func _on_add_topic_pressed() -> void:
	var fixed_prompt = newtopic_labels.text.strip_edges().to_lower()
	if fixed_prompt == "":
		AppMaster.emit_signal("console_message", "Write the list of labels that will be used to identify the database record.")
		return
	
	var fixed_text: String = newtopic_text.text.strip_edges()
	if fixed_text == "":
		AppMaster.emit_signal("console_message", "Enter the text you want to add to the database.")
		return

	var prompt_array = fixed_prompt.split(" ", false)
	if prompt_array.size() < 1:
		return

	var topic_key: String = AppMaster.get_random_key()
	var data = {"labels": prompt_array, "text": fixed_text}
	AppMaster.knowledge_data[topic_key] = data
	AppMaster.save_knowledge()
	add_item(topic_key)
	
	newtopic_labels.text = ""
	newtopic_text = ""
