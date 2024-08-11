extends StaticBody2D
class_name Breakable

@export var break_time: float = 0.2
@onready var level: Level = get_parent().get_parent()
var init_layer
var init_mask

func _ready():
	init_layer = collision_layer
	init_mask = collision_mask
	level.player_respawned.connect(respawn)

func _on_area_2d_body_entered(body):
	## Break if player is standing on top
	if body is PlayerCharacter:
		break_block.call_deferred()


func break_block():
	$Area2D/CollisionShape2D.disabled = true
	$LightOccluder2D.occluder_light_mask = 0
	AudioManager.block_break_sfx.play()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, break_time)
	await tween.finished
	collision_layer = 0
	collision_mask = 0

func respawn():
	$Area2D/CollisionShape2D.disabled = false
	modulate = Color.WHITE
	collision_layer = init_layer
	collision_mask = init_mask
	$LightOccluder2D.occluder_light_mask = 1	
