extends State
class_name PlayerState

# We store common variables and functions in here for convenience

@onready var player: CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var max_fall_velocity = 2000

func apply_gravity(delta: float):
	player.velocity.y = minf(player.velocity.y + (gravity * delta), max_fall_velocity)
	
