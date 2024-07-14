extends PlayerState
class_name PlayerJumpState

## STATE: includes the moment the player jumps until the time it lands
## handles jump apex gravity mod and air movement controls


#@export_range(0, 1.0) var jump_apex_mult: float = 0.7
@export_range(1, 3) var jump_release_mult: float = 2

var is_peak_reached: bool = false
var is_jump_released: bool = false

func enter():
	## We set these to true here because if the player jumps,
	## then it must have touched the ground, but may not have
	## been detected because of grace or coyote time
	player.has_dash = true
	player.has_double_jump = true
	
	# consumer buffer
	player.jump_buffer_timer.stop()
	# apply jump force
	player.velocity.y = player.jump_vel
	
	AudioManager.jump_sfx.play()

func exit():
	player.jump_grace_timer.stop()

func physics_update(delta: float):
	# left and right movement
	move_x(delta, player.air_move_mult)
	
	# halve velocity when releasing jump
	if Input.is_action_just_released("jump"):
		if player.velocity.y < 0:
			player.velocity.y /= 2
		transitioned.emit(self, "PlayerMoveState")
		return
	
	apply_gravity(delta)		
	
	player.move_and_slide()
	
	
	if grounded():
		transitioned.emit(self, "PlayerMoveState")
	elif dash():
		transitioned.emit(self, "PlayerDashState")
	elif double_jump():
		transitioned.emit(self, "PlayerDoubleJumpState")
		
