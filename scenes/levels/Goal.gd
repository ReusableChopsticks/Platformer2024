extends Area2D

@onready var level: Level = $".."

func _on_body_entered(body):
	print("GOAL REACHED")
	level.level_completed.emit(level.name.to_lower())
