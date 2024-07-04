extends CharacterBody2D

@onready var config: MoveConfig = $StateMachine/MoveConfig

# either -1 or 1 according to what the last direction was
var facing_dir = 1

var has_double_jump: bool = true
var has_dash: bool = true:
	get:
		print("GET: " + str(has_dash))
		return has_dash
	set(val):
		print("VAL: " + str(val))		
		has_dash = val
		print("SET: " + str(has_dash))

var jump_grace_timer: float = 0
var jump_buffer_timer: float = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# update grace time (aka coyote and buffer time)
	jump_grace_timer = maxf(0, jump_grace_timer - delta)
	jump_buffer_timer = maxf(0, jump_buffer_timer - delta)
	if is_on_floor():
		jump_grace_timer = config.jump_grace_time
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = config.jump_buffer_time
	
	# update what direction player is currently facing
	var dir = Input.get_axis("left", "right")
	if (dir != 0):
		facing_dir = dir
