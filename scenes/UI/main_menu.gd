extends CanvasLayer

var lvl_select = preload("res://scenes/UI/level_select_screen.tscn")

signal start_pressed
signal level_select_pressed
signal credits_pressed

func _on_start_button_pressed():
	#AudioManager.clair_de_lune.play()
	start_pressed.emit()

func _on_level_select_button_pressed():
	level_select_pressed.emit()

func _on_credits_button_pressed():
	credits_pressed.emit()
