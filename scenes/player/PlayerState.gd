extends State
class_name PlayerState

### An interface for player controls and common functions.

# We store common variables and functions in here for convenience

@onready var player: CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]
@onready var config: MoveConfig = $"../MoveConfig"

var jump_grace_timer: float = 0
var jump_buffer_timer: float = 0

# either -1 or 1 according to what the last direction was
var player_facing_dir = 1

var has_double_jump: bool = true
var has_dash: bool = true

func _ready():
	pass

func _physics_process(delta):
	#DEBUGGING
	#print("X VELOCITY: %s" % player.velocity.x)
	
	# update grace time (aka coyote and buffer time)
	jump_grace_timer = maxf(0, jump_grace_timer - delta)
	jump_buffer_timer = maxf(0, jump_buffer_timer - delta)
	if player.is_on_floor():
		jump_grace_timer = config.jump_grace_time
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = config.jump_buffer_time
	
	# update what direction player is currently facing
	var dir = Input.get_axis("left", "right")
	if (dir != 0):
		player_facing_dir = dir
		
		

# following the kinematics formula: next_v = curr_v + accel * delta_time * mult
func apply_gravity(delta: float, multiplier: float = 1):
	player.velocity.y = minf(player.velocity.y + (config.gravity * delta * multiplier), config.max_fall_speed)

# @description: moves player and direction gets handled for you
# @@@ CONTRACT @@@
# @param weight: what to multiply the acceleration rate with, within range (0, infinity)
func move_x(delta: float, multiplier: float = 1):
	var direction = signf(Input.get_axis("left", "right"))
	
	var vel = player.velocity.x + (multiplier * config.move_accel * direction * delta)
	
	# apply counter force when moving in opposite direction
	if (direction and player.velocity.x and direction != signf(player.velocity.x)):
		vel += direction * config.move_speed * config.counter_dir_force_mult * delta
	
	player.velocity.x = clampf(vel, -config.move_speed, config.move_speed)

# applies a friction force against the current velocity of the player
func friction_x(delta: float, multiplier: float = 1):
	var dir = signf(player.velocity.x)
	if (is_zero_approx(player.velocity.x)):
		# stop applying friction if the player has stopped
		return
	if (is_equal_approx(dir, 1)):
		player.velocity.x = maxf(0, player.velocity.x - (config.friction_decel * delta * multiplier))
	elif (is_equal_approx(dir, -1)):
		player.velocity.x = minf(0, player.velocity.x + (config.friction_decel * delta * multiplier))

#region check player controls
func grounded():
	return player.is_on_floor()
	
func jump():
	# check input
	var jump = Input.is_action_pressed("jump")
	# check if either grace or buffer is active
	if (jump):
		jump = jump_grace_timer > 0
	if (jump):
		jump = jump_buffer_timer > 0 and player.is_on_floor()
	return jump

func dash():
	return Input.is_action_pressed("dash") and has_dash
	
#endregion
