extends AudioStreamPlayer


func _ready():
	AppMaster.play_sound.connect(Callable(self, "play_sound_effect"))


func play_sound_effect(sound_file: String):
	var ss = "res://resources/sounds/effects/" + sound_file
	self.stream.load(ss)
	self.play()
