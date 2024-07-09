extends CharacterBody2D
class_name PlayerCharacter

@export_group("Movement")
@export var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
## The base max move speed without any multipliers
@export var base_speed: int = 200
## the calculated speed calculated using base_speed and speed_level
var move_speed: int
## Current speed level in range [1, max_speed_level]
var speed_level: int = 1
@export var speed_increase_amount: float = 0.5
@export var max_speed_level: int = 4

## Percentage of move speed to apply as counter force when moving in the opposite direction
## used in move_x()
@export_range(0, 3.0) var counter_dir_force_mult: float = 0.8
## The time it takes for player to accelerate to base speed
@export_range(0.01, 1.0) var time_to_max_speed: float = 0.5
## Move acceleration value calculated from time_to_max_speed
var move_accel: float = move_speed / time_to_max_speed
## The time it takes for player to stop from base speed (due to friction)
@export_range(0.01, 1.0) var time_to_stop: float = 0.3
## Friction deceleration value calculated from time_to_stop 
var friction_decel: float

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
@export_range(0, 5) var fast_fall_mult: float = 1.5
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
# note: all jump types use the same buffer timer and "consume" it when used 
# i.e. jump_buffer_timer.stop() on the state's enter function
#endregion

## calculate movement values every time speed_level is changed
func calculate_forces():
	# for every above 1, add mult_increment to the multiplier
	# 						   1 + speed_increase_amount(n - 1) 
	move_speed = base_speed * (1 + (speed_increase_amount * (speed_level - 1)))
	move_accel = move_speed / time_to_max_speed
	friction_decel = move_speed / time_to_stop
	#print(str(base_speed) + " * " + str(speed_level) + " = " + str(move_speed))

func increment_speed_level():
	modulate = Color.BLACK
	speed_level = min(speed_level + 1, max_speed_level)
	calculate_forces()

func reset_speed_level():
	modulate = Color.WHITE
	speed_level = 1
	calculate_forces()

# initial value calculations
func _ready():
	calculate_forces()

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
	#print(velocity)
	#print(jump_grace_timer.time_left)
	#if is_on_wall():
		#$Sprite2D.modulate = Color.BLACK
	#else:
		#$Sprite2D.modulate = Color.WHITE
	#print(move_speed)
