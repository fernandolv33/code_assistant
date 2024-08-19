extends Label

# Add this code to any element that should have text that scales with the screen
var font_reference_size: float
var resizeMe

func _ready():
	get_tree().get_root().size_changed.connect(Callable(self, "resize_me"))
	font_reference_size = self.get("theme_override_font_sizes/font_size")
	resizeMe = ResizableFont.new(font_reference_size)
	resize_me()


func resize_me():
	var new_font_size = resizeMe.get_font_size()
	self.set("theme_override_font_sizes/font_size", new_font_size)
