extends Node2D

@onready var level: Level = get_parent()

func _ready():
	$AnimationPlayerBob.play("goal_idle")
	$AnimationPlayerFlicker.play("flicker")

func _on_area_2d_body_entered(body):
	if body is PlayerCharacter:
		## This noise is annoying lol
		#AudioManager.level_complete_sfx.play()
		var level_name = level.name.to_lower()
		level.level_completed.emit(level_name)
