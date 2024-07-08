extends CharacterBody2D
class_name PlayerCharacter

@export_group("Movement")
@export var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
## The base max move speed without any multipliers
@export var move_speed: int = 400
## Percentage of move speed to apply as counter force when moving in the opposite direction (used in move_x())
@export_range(0, 3.0) var counter_dir_force_mult: float = 0.8

## The time it takes for player to accelerate to base speed
@export_range(0.01, 1.0) var time_to_max_speed: float = 0.5
var move_accel: float = move_speed / time_to_max_speed ## Move acceleration value calculated from time_to_max_speed
## The time it takes for player to stop from base speed (due to friction)
@export_range(0.01, 1.0) var time_to_stop: float = 0.3
var friction_decel: float ## Friction deceleration value calculated from time_to_stop

## Gravity multiplier when at the apex of jump
@export_range(0, 1.0) var jump_apex_mult: float = 0.7
## When to stop applying jump apex multiplier
@export_range(0, 1.0) var jump_apex_range: int = 200

@export_subgroup("Air")
## Multiplier for movement force in the air
@export_range(0, 1) var air_move_mult: float = 0.7
## Multiplier for air friction (which is lower than ground friction)
@export_range(0, 1) var air_friction_mult: float = 0.2
## Gravity multiplier when falling
@export_range(0, 1) var fast_fall_mult: float = 1.5
@export_subgroup("")

@export_subgroup("Limits")
## The upper limit of move speed which cannot be exceeded, even with multipliers
@export var max_move_speed: int = 3000
## The upper limit of fall speed which cannot be exceeded, even with multipliers
@export var max_fall_speed: int = 600
@export_subgroup("")

#region Internal values
# either -1 or 1 according to what the last direction was
var facing_dir = 1

# These are set to true while grounded in MoveState, false when used up
var has_double_jump: bool = true
var has_dash: bool = true

@onready var jump_buffer_timer: Timer = $Timers/JumpBufferTimer
@onready var jump_grace_timer: Timer = $Timers/JumpGraceTimer
@onready var wall_jump_grace_timer: Timer = $Timers/WallJumpGraceTimer
# note: all jump types use the same buffer timer and "consume" it when used (set time to 0)
#endregion

# initial value calculations
func _ready():
	move_accel = move_speed / time_to_max_speed
	friction_decel = move_speed / time_to_stop

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Handle resetting timers
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer.start()
	if is_on_floor():
		jump_grace_timer.start()
	if is_on_wall_only():
		wall_jump_grace_timer.start()
	
	# update what direction player is currently facing
	var dir = Input.get_axis("left", "right")
	if (dir != 0):
		facing_dir = dir
	
	## Debugging
	#print(velocity.x)
	#print(jump_grace_timer.time_left)
	#if is_on_wall():
		#$Sprite2D.modulate = Color.BLACK
	#else:
		#$Sprite2D.modulate = Color.WHITE
		
