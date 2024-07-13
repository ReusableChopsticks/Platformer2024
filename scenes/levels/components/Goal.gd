extends Node2D

@onready var level: Level = get_parent()

func _ready():
	$AnimationPlayer.play("goal_idle")

func _on_area_2d_body_entered(body):
	if body is PlayerCharacter:
		var level_name = level.name.to_lower()
		level.level_completed.emit(level_name)
