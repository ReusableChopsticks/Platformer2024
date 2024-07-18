extends Node2D

var init_col_layer
var init_col_mask
var not_broken = true

func _ready():
	init_col_layer = $StaticBody2D.collision_layer
	init_col_mask = $StaticBody2D.collision_mask
	disable_col()

func enable_col():
	$StaticBody2D.collision_layer = init_col_layer
	$StaticBody2D.collision_mask = init_col_mask
func disable_col():
	$StaticBody2D.collision_layer = 0
	$StaticBody2D.collision_mask = 0

func _on_area_2d_body_entered(body):
	if body is PlayerCharacter:
		if not body.states.current_state is PlayerDashState:
			print("Not dashing but " + body.states.current_state.name)
			enable_col()
		elif body.speed_level <= 1:
			print("Not fast enough")
			enable_col()
		else:
			break_barrier()
	
	## TODO: just break through 
	#print("boyd entered")
	#if body is PlayerCharacter:
		#if not body.states.current_state is PlayerReboundState:
			#print("not dashing but is instead " + body.states.current_state.name)
			#return
		#if body.speed_level == 1:
			#print("not fast enough")
			#return
		#print("valid")
		#break_barrier()

func _on_area_2d_body_exited(body):
	if body is PlayerCharacter and not_broken:
		disable_col()


func break_barrier():
	not_broken = false
	$StaticBody2D.collision_layer = 0
	$StaticBody2D.collision_mask = 0
	$Area2D.collision_layer = 0
	$Area2D.collision_mask = 0
	
	get_tree().create_tween().tween_property(self, "modulate", Color.TRANSPARENT, 0.1)


