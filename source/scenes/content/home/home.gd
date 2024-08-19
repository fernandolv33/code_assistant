extends MarginContainer

@onready var prompt = $Content/Header/Prompt
@onready var prompt_label = $Content/Results/PromptLabel
@onready var prompt_results = $Content/Results/S/List


var answer_item = preload("res://scenes/content/knowledge/answer_item.tscn")

func _ready() -> void:
	AppMaster.load_knowledge()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		search()


func search() -> void:
	var fixed_prompt = prompt.text.strip_edges().to_lower()
	if fixed_prompt == "":
		return
	
	var prompt_array = fixed_prompt.split(" ", false)
	if prompt_array.size() < 1:
		return
	prompt_label.text = "Results for: %s" % fixed_prompt
	prompt.text = ""
	perform_search(prompt_array)


func clear_data():
	for i in prompt_results.get_children():
		i.queue_free()


func perform_search(prompt_array):
	clear_data()
	var results = []
	for i in AppMaster.knowledge_data:
		var found_tokens: int = 0
		for j in prompt_array:
			if j in AppMaster.knowledge_data[i].labels:
				found_tokens += 1
		if found_tokens > 0:
			var intent_ratio:float = (0.8 * (found_tokens / prompt_array.size())) + (0.2 * found_tokens / AppMaster.knowledge_data[i].labels.size())
			results.append([i, intent_ratio])

	results.sort_custom(func(a, b): return a[1] > b[1])
	var better_value: float = results[0][1]
	
	if results.size() == 0:
		prompt_label.text += ". No results found."
		AppMaster.emit_signal("console_message", "No records found.")
		return

	var displayed_records: int = 0
	for i in results:
		if better_value - 0.5 > i[1]:
			continue
		if better_value/3 > i[1]:
			continue
			 
		var ii = answer_item.instantiate()
		prompt_results.add_child(ii)
		ii.init_item(i[0], i[1])
		displayed_records += 1
	AppMaster.emit_signal("console_message", "Displaying %d relevant records displayed. %d records found." % [displayed_records, results.size()])
