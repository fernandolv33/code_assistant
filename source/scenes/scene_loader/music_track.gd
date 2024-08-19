extends AudioStreamPlayer

var music_tracks = []

func _ready():
	AppMaster.play_music_track.connect(Callable(self, "play_music_track"))
	self.finished.connect(Callable(self, "end_music_track"))

# Uncomment next two lines to create a jukebox
#	get_list_of_tracks()
#	play_music_track(music_tracks.pick_random())


func get_list_of_tracks():
	var d = DirAccess.open("res://resources/sounds/music/")
	if d:
		d.list_dir_begin()
		var file_name = d.get_next()
		while file_name != "":
			if not d.current_is_dir():
				music_tracks.append(file_name)
			file_name = d.get_next()


func play_music_track(sound_file: String):
	if self.playing:
		self.stop()
	var ss = "res://resources/sounds/music/" + sound_file
	self.stream.load(ss)
	self.play()


func end_music_track():
	pass
	# Uncomment next line to play a random track
#	play_music_track(music_tracks.pick_random())
