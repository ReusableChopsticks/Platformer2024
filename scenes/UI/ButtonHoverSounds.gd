extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	focus_entered.connect(on_focus)
	mouse_entered.connect(on_focus)

func on_hover():
	AudioManager.button_hover_sfx.play()
	
func on_focus():
	AudioManager.button_hover_sfx.play()
