extends CanvasLayer

var lvl_select = preload("res://scenes/UI/level_select_screen.tscn")

signal start_pressed
signal level_select_pressed
signal credits_pressed

func _ready():
	focus()

func focus():
	%StartButton.grab_focus()


func _on_start_button_pressed():
	#AudioManager.clair_de_lune.play()
	start_pressed.emit()

func _on_level_select_button_pressed():
	level_select_pressed.emit()

func _on_credits_button_pressed():
	credits_pressed.emit()


func _on_level_select_button_visibility_changed():
	if visible:
		focus()
