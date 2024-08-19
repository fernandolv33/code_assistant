extends MarginContainer

var new_game_panel = preload("res://scenes/top_menu/new_game.tscn")
var load_game_panel = preload("res://scenes/top_menu/load_game.tscn")
var configuration_panel = preload("res://scenes/top_menu/configuration.tscn")
var about_panel = preload("res://scenes/top_menu/about.tscn")


func _ready():
	AppMaster.top_menu_event.connect(Callable(self, "menu_event"))


func clear_menu():
	for i in self.get_children():
		i.queue_free()


func menu_event(event_type: int):
	clear_menu()
	if event_type == AppMaster.TOP_MENU_EVENTS.NEW_GAME:
		var ii = new_game_panel.instantiate()
		self.add_child(ii)
	elif event_type == AppMaster.TOP_MENU_EVENTS.CONTINUE:
		if not AppMaster.load_game_data(AppMaster.configuration["last_profile"]):
			var ii = new_game_panel.instantiate()
			self.add_child(ii)
	elif event_type == AppMaster.TOP_MENU_EVENTS.LOAD_GAME:
		var ii = load_game_panel.instantiate()
		self.add_child(ii)
	elif event_type == AppMaster.TOP_MENU_EVENTS.CONFIG_GAME:
		var ii = configuration_panel.instantiate()
		self.add_child(ii)
	elif event_type == AppMaster.TOP_MENU_EVENTS.ABOUT:
		var ii = about_panel.instantiate()
		self.add_child(ii)
	elif event_type == AppMaster.TOP_MENU_EVENTS.QUIT:
		get_tree().quit()
