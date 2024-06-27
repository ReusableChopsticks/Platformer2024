extends Node
class_name MoveConfig

@export var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
# the base move speed at normal walking pace
@export var move_speed: int = 400
# percentage of move_speed to apply as counter force when moving in the opposite direction (used in move_x())
@export_range(0, 3.0) var counter_dir_force_mult: float = 0.8

# The time it takes for player to accelerate to base speed
@export_range(0.01, 1.0) var time_to_max_speed: float = 0.5
var move_accel: int = move_speed / time_to_max_speed
# The time it takes for player to stop from base speed (due to friction)
@export_range(0.01, 1.0) var time_to_stop: float = 0.3
var friction_decel: int
#@export_range(0.0, 1.0) var move_lerp: float = 0.5
@export var max_move_speed: int = 3000
@export var max_fall_speed: int = 2000

func _ready():
	move_accel = move_speed / time_to_max_speed
	friction_decel = move_speed / time_to_stop
