extends Node2D

## The speed level you are required to be at to dash through and break
# (numbers match up exactly with actual player speed values)
@export_range(2, 4) var speed_level: int = 2

var init_col_layer
var init_col_mask
var not_broken = true

const SPEED_COLOUR = {
	2: Color.LEMON_CHIFFON, # 1 rebound speed
	3: Color.PALE_GREEN, # 2 rebounds speed
	4: Color.SKY_BLUE # 3 rebounds speed
}

func _ready():
	init_col_layer = $StaticBody2D.collision_layer
	init_col_mask = $StaticBody2D.collision_mask
	modulate = SPEED_COLOUR[speed_level]
	disable_col()

func enable_col():
	$StaticBody2D.collision_layer = init_col_layer
	$StaticBody2D.collision_mask = init_col_mask
func disable_col():
	$StaticBody2D.collision_layer = 0
	$StaticBody2D.collision_mask = 0

func _on_area_2d_body_entered(body):
	if body is PlayerCharacter:
		if not body.states.current_state is PlayerDashState:
			print("Not Dash but instead " + body.states.current_state.name)
			enable_col()
		elif body.speed_level < speed_level:
			print("Not fast enough")
			enable_col()
		else:
			break_barrier()


func _on_area_2d_body_exited(body):
	if body is PlayerCharacter and not_broken:
		disable_col()


func break_barrier():
	not_broken = false
	$StaticBody2D.collision_layer = 0
	$StaticBody2D.collision_mask = 0
	$Area2D.collision_layer = 0
	$Area2D.collision_mask = 0
	AudioManager.block_break_sfx.play()
	get_tree().create_tween().tween_property(self, "modulate", Color.TRANSPARENT, 0.1)
