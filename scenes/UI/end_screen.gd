extends CanvasLayer

## Must be instantiated as a child of LevelManager

var player_stats: Resource = preload("res://scenes/player/PlayerStats.tres")

signal quit_to_main_menu

func _ready():
	%TimeNote.hide()
	var level_manager = $".."
	%Deaths.text = str(player_stats.total_deaths)
	if level_manager.start_time == -1:
		%Time.text = "INVALID"
		%TimeNote.show()
	else:
		%Time.text = Calc.format_minutes(level_manager.completion_time)
		
		## Update best time
		if level_manager.completion_time < player_stats.best_time:
			player_stats.best_time = level_manager.completion_time
			%Time.text += "   (New best!)"
		elif player_stats.best_time == -1: # no time set yet
			player_stats.best_time = level_manager.completion_time
			%Time.text += "   (New best!)"
	
	$AnimationPlayer.play("cutscene")

func _on_main_menu_button_pressed():
	%TimeNote.hide()
	quit_to_main_menu.emit()


func _on_animation_player_animation_finished(_anim_name):
	%MainMenuButton.grab_focus()
