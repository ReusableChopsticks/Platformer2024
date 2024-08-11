extends Node
class_name GameManager

@onready var main_menu = $MenuScreen
@onready var level_select = $LevelSelectScreen
@onready var level_manager: LevelManager = $LevelManager
@onready var credits = $Credits

var player_stats: Resource = preload("res://scenes/player/PlayerStats.tres")

func _ready():
	player_stats.load_game()

## Save game before closing the app
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		player_stats.save_game()
		get_tree().quit()

func _on_menu_screen_credits_pressed():
	credits.show()
	main_menu.hide()

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
	main_menu.focus()


func _on_credits_back_pressed():
	credits.hide()
	main_menu.show()
