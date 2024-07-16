extends Node
class_name GameManager

@onready var main_menu = $MenuScreen
@onready var level_select = $LevelSelectScreen
@onready var level_manager: LevelManager = $LevelManager

var player_stats: Resource = preload("res://scenes/player/PlayerStats.tres")

func _on_menu_screen_credits_pressed():
	pass # Replace with function body.


func _on_menu_screen_level_select_pressed():
	main_menu.hide()
	level_select.show()
	

func _on_level_select_screen_back_pressed():
	level_select.hide()
	main_menu.show()


func _on_menu_screen_start_pressed():
	level_manager.load_current_level()
	main_menu.hide()
	AudioManager.clair_de_lune.play()



func _on_level_manager_quit_level():
	level_manager.quit_to_main_menu()
	AudioManager.clair_de_lune.stop()	
	main_menu.show()
