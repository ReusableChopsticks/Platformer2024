extends State
class_name PlayerState

# We store common variables and functions in here for convenience

@onready var player: CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# the base move speed at normal walking pace
@export var move_speed: int = 300
# The time it takes for player to accelerate to base speed
@export_range(0.0, 1.0) var time_to_max_speed: float = 0.7
var move_accel: int = move_speed / time_to_max_speed
# The time it takes for player to stop from base speed (due to friction)
@export_range(0.0, 1.0) var time_to_stop: float = 0.5
var friction_decel: int = move_speed / time_to_stop
#@export_range(0.0, 1.0) var move_lerp: float = 0.5
@export var max_move_speed: int = 3000
@export var max_fall_speed: int = 2000



func _physics_process(delta):
	#DEBUGGING
	#print("X VELOCITY: %s" % player.velocity.x)
	pass

func apply_gravity(delta: float, multiplier: float = 1):
	player.velocity.y = minf(player.velocity.y + (gravity * delta * multiplier), max_fall_speed)

# @description: moves player and direction gets handled for you
# @@@ CONTRACT @@@
# @param weight: what to multiply the acceleration rate with, within range (0, infinity)
func move_x(delta: float, multiplier: float = 1):
	var direction = signf(Input.get_axis("left", "right"))
	#player.velocity.x = lerpf(player.velocity.x, target_speed * direction, weight)
	var vel = player.velocity.x + (multiplier * move_accel * direction * delta)
	player.velocity.x = clampf(vel, -move_speed, move_speed)

# applies a friction force AGAINST the supplied direction (the current direction of the player)
func friction_x(delta: float, dir: int, multiplier: float = 1):
	if (is_zero_approx(player.velocity.x)):
		# stop applying friction if the player has stopped
		return
	if (is_equal_approx(dir, 1)):
		player.velocity.x = maxf(0, player.velocity.x - (friction_decel * delta * multiplier))
	elif (is_equal_approx(dir, -1)):
		player.velocity.x = minf(0, player.velocity.x + (friction_decel * delta * multiplier))
