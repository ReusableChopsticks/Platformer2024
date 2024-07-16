extends CanvasLayer


func _on_start_button_pressed():
	AudioManager.clair_de_lune.play()
	get_tree().change_scene_to_file("res://scenes/levels/manager/level_manager.tscn")
