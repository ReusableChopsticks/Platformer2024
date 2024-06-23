extends State
class_name PlayerState

# We store common variables and functions in here for convenience

@onready var player: CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var move_speed: int = 300
@export var move_accel: int = 500 # units per second
@export_range(0.0, 1.0) var move_lerp: float = 0.5 #TODO: replace with acceleration code
@export var max_move_speed: int = 3000
@export var max_fall_speed: int = 2000

func _physics_process(delta):
	#DEBUGGING
	print("X VELOCITY: %s" % player.velocity.x)
	pass

func apply_gravity(delta: float):
	player.velocity.y = minf(player.velocity.y + (gravity * delta), max_fall_speed)

# target_velocity should be multiplied by delta before being passed in
# direction gets handled for you
func move_x(delta: float, weight: float):
	var direction = signf(Input.get_axis("left", "right"))
	#player.velocity.x = lerpf(player.velocity.x, target_speed * direction, weight)
	var vel = player.velocity.x + (weight * move_accel * direction * delta)
	player.velocity.x = clampf(vel, -max_move_speed, max_move_speed)


func friction_x(delta: float, curr_dir: int, decel_rate):
	if (player.velocity.x == 0):
		# stop applying friction if the player has stopped
		return
	if (curr_dir == 1):
		player.velocity.x = maxf(0, player.velocity.x - (decel_rate * delta))
	elif (curr_dir == -1):
		player.velocity.x = minf(0, player.velocity.x + (decel_rate * delta))
