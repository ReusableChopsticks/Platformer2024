extends Node2D

## The speed level you are required to be at to dash through and break
# (numbers match up exactly with actual player speed values)
@export_range(2, 4) var speed_level: int = 2
@onready var level: Level = get_parent().get_parent()

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
	level.player_respawned.connect(respawn)

func enable_col():
	$StaticBody2D.collision_layer = init_col_layer
	$StaticBody2D.collision_mask = init_col_mask
func disable_col():
	$StaticBody2D.collision_layer = 0
	$StaticBody2D.collision_mask = 0

## Check what speed the player is at after rebounding and destroy accordingly
## Because this check happens after the rebound and speed recalculation,
## we offset by 1 from the speed to check
## and use a special variable for speed level 4 barriers.
func _on_area_2d_body_entered(body):
	#if body is PlayerCharacter:
		#if not (body.states.current_state is PlayerReboundState):
			#print("Not Dash/Rebound but instead " + body.states.current_state.name)
			#return
		#if body.speed_level < speed_level + 1 and speed_level < 4:
			#print("Not fast enough")
			#return
		#if speed_level == 4 and not body.rebounded_at_max_speed:
			#print("Not fast enough (MAX SPEED)")
			#return
		#
		#break_barrier()
	pass


func _on_area_2d_body_exited(body):
	if body is PlayerCharacter:
		if not (body.states.current_state is PlayerReboundState):
			#print("Not Dash/Rebound but instead " + body.states.current_state.name)
			return
		if body.speed_level < speed_level + 1 and speed_level < 4:
			#print("Not fast enough")
			return
		if speed_level == 4 and not body.rebounded_at_max_speed:
			#print("Not fast enough (MAX SPEED)")
			return
		
		break_barrier()

## Barrier break animation and collision toggling
func break_barrier():
	not_broken = false
	disable_col()
	$Area2D.collision_layer = 0
	$Area2D.collision_mask = 0
	AudioManager.block_break_sfx.play()
	get_tree().create_tween().tween_property(self, "modulate", Color.TRANSPARENT, 0.1)

func respawn():
	not_broken = true
	modulate = SPEED_COLOUR[speed_level]
	enable_col()
	$Area2D.collision_layer = 2
	$Area2D.collision_mask = 1
