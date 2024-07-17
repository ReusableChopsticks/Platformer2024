extends CanvasLayer

var lvl_select = preload("res://scenes/UI/level_select_screen.tscn")
var player_stats: Resource = preload("res://scenes/player/PlayerStats.tres")

var first_input := true

signal start_pressed
signal level_select_pressed
signal credits_pressed

func _ready():
	update_display()

func update_display():
	focus()
	var x = Calc.format_minutes(player_stats.best_time)
	if x == "Not set yet!":
		$BestTime.hide()
		$BestTimeLabel.hide()
	else:
		$BestTime.text = x
		$BestTime.show()
		$BestTimeLabel.show()
		

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
		update_display()
