extends State
class_name PlayerState

### An interface for player controls and common functions.

# We store common variables and functions in here for convenience

@onready var player: CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]
@onready var config: MoveConfig = $"../MoveConfig"



func _physics_process(delta):
	#DEBUGGING
	#print("X VELOCITY: %s" % player.velocity.x)
	pass

# next_v = curr_v + accel * delta_time * mult
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
		print("COUNTER!!!")
	
	player.velocity.x = clampf(vel, -config.move_speed, config.move_speed)

# applies a friction force AGAINST the supplied direction (the current direction of the player)
func friction_x(delta: float, dir: int, multiplier: float = 1):
	if (is_zero_approx(player.velocity.x)):
		# stop applying friction if the player has stopped
		return
	if (is_equal_approx(dir, 1)):
		player.velocity.x = maxf(0, player.velocity.x - (config.friction_decel * delta * multiplier))
	elif (is_equal_approx(dir, -1)):
		player.velocity.x = minf(0, player.velocity.x + (config.friction_decel * delta * multiplier))
