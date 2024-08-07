extends CharacterBody2D
class_name PlayerCharacter

signal player_died
## The player state machine which holds reference to the current state
@onready var states: StateMachine = $StateMachine
## If the player is dead or not
var has_died := false

@export_group("Graphics")
## The scene to instantiate as the player ghost.
## This should be a Sprite2D the same dimensions as the player (or just the exact same sprite)
@export var ghost_node: PackedScene
## How many ghost instances to spawn per second.
## NOTE: if this value is too high, no trail will spawn
@export_range(1, 10) var base_ghost_freq: int = 10

## Controls when to spawn ghost instances based on frequency
@onready var ghost_timer: Timer = $Timers/GhostTimer
@export_group("")

@export_group("Movement")
## The base max move speed without any multipliers
@export var base_speed: int = 200
## the calculated speed calculated using base_speed and speed_level
var move_speed: int
## Current speed level in range [1, max_speed_level]
var speed_level: int = 1
## The percentage of base speed to be added on to move speed for each speed level
@export var speed_increase_amount: float = 0.5
## The max amount of times you can increase your speed on rebounds + 1
@export var max_speed_level: int = 4

## Percentage of move speed to apply as counter force when moving in the opposite direction
## used in move_x()
@export_range(0, 5.0) var counter_dir_force_mult: float = 0.8
## The time it takes for player to accelerate to base speed
@export_range(0.01, 1.0) var time_to_max_speed: float = 0.5
## Move acceleration value calculated from time_to_max_speed
var move_accel: float = move_speed / time_to_max_speed
## The time it takes for player to stop from base speed (due to friction)
@export_range(0.01, 1.0) var time_to_stop: float = 0.3
## Friction deceleration value calculated from time_to_stop 
var friction_decel: float



@export_subgroup("Jump")
@export var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
## Time it takes to reach peak of jump
## Used to calculate initial jump_vel
@export var time_to_jump_peak: float = 0.3
## Desired jump height in pixels
@export var jump_height = 24

## Base jump velocity
var jump_vel: int
## Jump velocity for wall jump
var wall_jump_vel: int
## Jump velocity for double jump
var double_jump_vel: int
## y velocity to apply when rebounding off a wall.
var rebound_y_vel: int
## y velocity to apply when rebounding off the floor.
var floor_rebound_vel: int

## Gravity multiplier when at the apex of jump
@export_range(0, 1.0) var jump_apex_mult: float = 0.7
## What y velocity to stop applying jump apex multiplier 
## in range [0, jump_apex_range]
@export var jump_apex_range: int = 200

## Multiplier for rebound jump
@export_range(1, 2) var floor_rebound_vel_mult: float = 1.4
@export_subgroup("")

@export_subgroup("Air")
## Multiplier for movement force in the air
@export_range(0, 1) var air_move_mult: float = 0.7
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
## either -1 or 1 according to what the last direction was
var facing_dir = 1
## Keep track of last rebound dir so rebounds must alternate walls
var last_rebound_dir = 0

## These are set to true while grounded in MoveState, false when used up
var has_double_jump: bool = true
var has_dash: bool = true

@onready var jump_buffer_timer: Timer = $Timers/JumpBufferTimer
@onready var jump_grace_timer: Timer = $Timers/JumpGraceTimer
@onready var wall_jump_grace_timer: Timer = $Timers/WallJumpGraceTimer
@onready var dash_buffer_timer: Timer = $Timers/DashBufferTimer
# note: all jump types use the same buffer timer and "consume" it when used 
# i.e. jump_buffer_timer.stop() on the state's enter function

## Used to check if player is close to the ground to prevent double jump
@onready var ground_ray_cast: RayCast2D = $GroundCheckRayCast
#endregion

const SPEED_COLOUR = {
	1: Color.WHITE,
	2: Color.LEMON_CHIFFON,
	3: Color.PALE_GREEN,
	4: Color.SKY_BLUE
}

var player_stats: Resource = preload("res://scenes/player/PlayerStats.tres")

func ghost(is_ghosting: bool):
	if is_ghosting and ghost_timer.is_stopped():
		# increase ghost spawn frequency by 1 for each speed level
		var time: float = 1.0 / (base_ghost_freq + speed_level - 1)
		ghost_timer.start(time)
	elif !is_ghosting:
		ghost_timer.stop()

func _on_ghost_timer_timeout():
	var instance: PlayerGhost = ghost_node.instantiate()
	instance.global_position = global_position
	instance.self_modulate = modulate
	$GhostInstances.add_child(instance)
	
func _ready():
	has_died = false
	
	calculate_forces()
	
	## jumping numbers according to formulas
	# https://www.youtube.com/watch?v=hG9SzQxaCm8
	gravity = (2 * jump_height) / (time_to_jump_peak * time_to_jump_peak)
	jump_vel = floor(-(2 * jump_height) / time_to_jump_peak)
	wall_jump_vel = floor(jump_vel * 0.6)
	double_jump_vel = floor(jump_vel * 0.6)
	rebound_y_vel = floor(jump_vel * 0.3)
	floor_rebound_vel = floor(jump_vel * floor_rebound_vel_mult)

## calculate movement values every time speed_level is changed
func calculate_forces():
	## horizontal movement
	# for every above 1, add mult_increment to the multiplier
	# 						   1 + speed_increase_amount(n - 1) 
	move_speed = floor(base_speed * (1 + (speed_increase_amount * (speed_level - 1))))
	move_accel = move_speed / time_to_max_speed
	friction_decel = move_speed / time_to_stop
	#print(str(base_speed) + " * " + str(speed_level) + " = " + str(move_speed))

func increment_speed_level():
	speed_level = min(speed_level + 1, max_speed_level)
	calculate_forces()
	modulate = SPEED_COLOUR[speed_level]

func reset_speed_level():
	speed_level = 1
	## Reset last rebound so player can use any wall again to start
	last_rebound_dir = 0
	calculate_forces()
	modulate = SPEED_COLOUR[speed_level]
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if has_died:
		return
	
	# Handle resetting timers
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer.start()
	if is_on_floor():
		jump_grace_timer.start()
	if is_on_wall_only():
		wall_jump_grace_timer.start()
	
	if Input.is_action_just_pressed("dash"):
		dash_buffer_timer.start()
	
	# update what direction player is currently facing
	var dir = sign(Input.get_axis("left", "right"))
	if (dir != 0):
		facing_dir = dir
	
	## Ghost effect
	ghost(speed_level > 1)
	
	## Debugging
	#print(position)
	#print(jump_grace_timer.time_left)
	#if is_on_wall():
		#$Sprite2D.modulate = Color.BLACK
	#else:
		#$Sprite2D.modulate = Color.WHITE
	#print(move_speed)
	#print(speed_level)
	#print(velocity)
	#print(Input.is_action_pressed("jump"))

## Call this when the player should die
## Obstacles (like spikes) are responsible for detecting
## when the player should die
func die():
	if not has_died:
		die_deferred()

func die_deferred():
	has_died = true
	player_stats.total_deaths += 1
	AudioManager.death_sfx.play()
	
	## Disable ghost effect
	ghost_timer.stop()
	## TODO: This is a hacky death effect made by reusing the player ghost
	## Make this into something better maybe?
	# make so player cannot interact with anything
	collision_mask = 0
	collision_layer = 0
	visible = false
	# spawn death after image
	var img: PlayerGhost = ghost_node.instantiate()
	img.global_position = global_position
	img.self_modulate = Color.RED
	$GhostInstances.add_child(img)
	img.fade_time = 0.4
	await get_tree().create_timer(img.fade_time).timeout
	# emit player died after its all done
	player_died.emit()

## Kill player when player is off screen.
func _on_visible_on_screen_notifier_2d_screen_exited():
	die()
