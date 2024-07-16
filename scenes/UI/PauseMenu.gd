extends CanvasLayer

## Must be a child of LevelManager
## TODO: Make retries count towards total death count

## Whether or not to pause the gameplay when game is paused
@onready var level_manager = $".."
@export var halt_game: bool = true

signal quit_level

func _ready():
	visible = false
	%ResumeButton.grab_focus()

func _input(event):
	## Toggle visible on pressing escape and a level is currently loaded
	## (spaghetti code time because this node is always processing!!!)
	if event.is_action_pressed("ui_cancel") and level_manager.get_child_count() > 1:
		visible = !visible
		if visible:
			%ResumeButton.grab_focus()
	
	if halt_game:
		if visible:
			get_tree().paused = true
		else:
			get_tree().paused = false

func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioManager.BGM_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(AudioManager.BGM_BUS_ID, value < 0.05)

func _on_sound_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioManager.SFX_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(AudioManager.SFX_BUS_ID, value < 0.05)

func _on_resume_button_pressed():
	visible = false

func _on_retry_button_pressed():
	level_manager.current_level.respawn_player.call_deferred()
	AudioManager.death_sfx.play()
	visible = false
	get_tree().paused = false

func _on_quit_button_pressed():
	get_tree().paused = false
	hide()
	quit_level.emit()
