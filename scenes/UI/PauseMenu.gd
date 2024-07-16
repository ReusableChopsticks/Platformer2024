extends CanvasLayer



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		visible = !visible


func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioManager.BGM_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(AudioManager.BGM_BUS_ID, value < 0.05)

func _on_sound_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioManager.SFX_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(AudioManager.SFX_BUS_ID, value < 0.05)
