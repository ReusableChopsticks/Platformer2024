extends CanvasLayer

var player_stats: Resource = preload("res://scenes/player/PlayerStats.tres")

signal quit_to_main_menu

func _ready():
	%Deaths.text = str(player_stats.total_deaths)
	%Time.text = str($"..".completion_time / 1000) + "s"
	$AnimationPlayer.play("cutscene")

func _on_main_menu_button_pressed():
	quit_to_main_menu.emit()


func _on_animation_player_animation_finished(anim_name):
	$MarginContainer/VBoxContainer/MainMenuButton.grab_focus()
