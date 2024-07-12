extends Sprite2D
class_name PlayerGhost

@export var fade_time: float = 0.2

func _ready():
	ghosting()
	
func ghosting():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "self_modulate", Color.TRANSPARENT, fade_time)
	await tween.finished
	queue_free()
