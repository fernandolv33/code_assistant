extends Node


signal change_scene
signal play_sound
signal play_music_track
signal top_menu_event

signal select_project
signal todo_data_changed
signal todo_project_deleted
signal data_saved

signal console_message

enum TOP_MENU_EVENTS {NEW_GAME=0, CONTINUE=1, LOAD_GAME=2, CONFIG_GAME=3, ABOUT=4, QUIT=5}

const CONFIG_FILE = "user://config.data"

var configuration = {}
var profile = {}

var game_menu_available: bool = false
var game_alive: bool = false


var todo_data = {}
var knowledge_data = {}


func _ready():
	sanitize_folders()
	load_configuration()



#
# CONFIGURATION COMMON FUNCTIONS
#
func sanitize_folders():
	var dir = DirAccess.open("user://")
	if not dir.dir_exists("user://saves"):
		dir.make_dir("user://saves")


func load_configuration():
	var ff = FileAccess.open(CONFIG_FILE, FileAccess.READ)
	if not ff:
		init_configuration()
		save_configuration()
		return
	configuration = ff.get_var()
	sanitize_configuration()


func save_configuration():
	var ff = FileAccess.open(CONFIG_FILE, FileAccess.WRITE)
	ff.store_var(configuration)


func init_configuration():
	configuration = {}
	configuration["full_screen"] = false
	configuration["screen_size"] = Vector2(1152,648)
	configuration["sound_master"] = 100
	configuration["sound_music"] = 100
	configuration["sound_effects"] = 100
	configuration["last_profile"] = ""


func sanitize_configuration():
	if not configuration.has("full_screen"):
		configuration["full_screen"] = false
	if not configuration.has("screen_size"):
		configuration["screen_size"] = Vector2(1152,648)
	if not configuration.has("sound_master"):
		configuration["sound_master"] = 100
	if not configuration.has("sound_music"):
		configuration["sound_music"] = 100
	if not configuration.has("sound_effects"):
		configuration["sound_effects"] = 100
	if not configuration.has("last_profile"):
		configuration["last_profile"] = ""


func create_profile(name: String, file: String):
	profile = {}
	profile["name"] = name
	profile["file"] = file
	profile["current_scene"] = "game_intro/new_game"
	save_game_data(file)



func get_list_of_saves():
	var dir = DirAccess.open("user://saves")
	var saves = []
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				saves.append(file_name.get_basename())
			file_name = dir.get_next()
	return saves


func load_game_data(filename: String = "autosave") -> bool:
	var ff = FileAccess.open("user://saves/%s.sav" % filename, FileAccess.READ)
	if not ff:
		return false
	profile = ff.get_var()
	emit_signal("change_scene", profile["current_scene"])
	return true


func save_game_data(filename: String = "autosave"):
	var ff = FileAccess.open("user://saves/%s.sav" % filename, FileAccess.WRITE)
	ff.store_var(profile)


func delete_save_data(filename: String):
	var ss: String = "user://saves/%s.sav" % filename
	DirAccess.remove_absolute(ss)
#	OS.move_to_trash(ss)


func sanitize_name(pname: String) -> String:
	var cleaning_array = [" ", ".", ",", "/", "+", "*", ";", "\\"]
	var clean_name: String
	clean_name = pname
	for i in cleaning_array:
		clean_name = clean_name.replace(i, "_")
	clean_name = clean_name.to_lower()
	return clean_name


func get_current_date() -> String:
	var time_dict = Time.get_datetime_dict_from_system()
	return "%d-%02d-%02d" % [time_dict.year, time_dict.month, time_dict.day]
	# { "year": 2024, "month": 5, "day": 15, "weekday": 3, "hour": 7, "minute": 43, "second": 59, "dst": true }


func load_todo() -> bool:
	var ff = FileAccess.open("user://saves/todo.json", FileAccess.READ)
	if not ff:
		return false
	var json_string: String = ff.get_as_text()
	var json = JSON.new()
	var error = json.parse(json_string)
	if error == OK:
		todo_data= json.data
		return true
	return false


func save_todo():
	var ff = FileAccess.open("user://saves/todo.json", FileAccess.WRITE)
	ff.store_string(JSON.stringify(todo_data))
	AppMaster.emit_signal("console_message", "Data saved.")
	AppMaster.emit_signal("data_saved")



func load_knowledge() -> bool:
	var ff = FileAccess.open("user://saves/knowledge.json", FileAccess.READ)
	if not ff:
		return load_knowledge_from_default_dataabase()
	var json_string: String = ff.get_as_text()
	var json = JSON.new()
	var error = json.parse(json_string)
	if error == OK:
		knowledge_data= json.data
		return true
	return false


func save_knowledge():
	var ff = FileAccess.open("user://saves/knowledge.json", FileAccess.WRITE)
	ff.store_string(JSON.stringify(knowledge_data))
	AppMaster.emit_signal("console_message", "Data saved.")
	AppMaster.emit_signal("data_saved")


func load_knowledge_from_default_dataabase() -> bool:
	var ff = FileAccess.open("res://data/knowledge.json", FileAccess.READ)
	if not ff:
		return false
	var json_string: String = ff.get_as_text()
	var json = JSON.new()
	var error = json.parse(json_string)
	if error == OK:
		knowledge_data= json.data
		return true
	return false



func get_random_key() -> String:
	var code = "abcdefghijklmnopqrstuvwxyz0123456789"
	var tmp_id: String = ""
	for i in range(0,12):
		tmp_id += code[randi() % code.length()]

	return tmp_id


#func read_json_file(filename: String):
	#var ff = FileAccess.open(filename, FileAccess.READ)
	#if not ff:
		#return {}
	#var json_string: String = ff.get_as_text()
	#var json = JSON.new()
	#var error = json.parse(json_string)
	#if error != OK:
		#return {}
	#return json.data
