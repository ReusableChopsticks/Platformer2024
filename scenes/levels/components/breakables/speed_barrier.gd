extends Node2D
class_name SpeedBarrierTile

## NOTE: 
## Due to how Godot detects static body collisions ahead of areas,
## part of the code to make these breakable blocks work is located
## in the player Dash state. The functions here are called there.

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
