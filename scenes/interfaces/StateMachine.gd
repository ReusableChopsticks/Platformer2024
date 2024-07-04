extends Node
class_name StateMachine

@export var initial_state: State
@export var show_state_label: bool = false
@onready var state_label: Label = $"../StateLabel"

var current_state: State
var states: Dictionary = {}

var history_stack: Array[String] = []

# get all children states and connect to "transitioned" signal in State.gd
func _ready():
	for child in get_children():
		if child is PlayerState:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_child_transition)
		else:
			printerr("State machine in %s has non-state child" % get_parent().name)
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state
		state_label.text = current_state.name
	
	# to show debug label text or not
	state_label.visible = show_state_label
		

func _process(delta):
	if current_state:
		current_state.update(delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if current_state:
		current_state.physics_update(delta)

"""
state: the state that called it (pass in self keyword)
new_state_name: what state you want to transition to
"""
func on_child_transition(state, new_state_name: String):
	if state != current_state:
		printerr("%s != %s. Current states do not match" % [state.name, current_state.name])
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		printerr("State %s tried to transition to %s which does not exist" % [state.name, new_state_name])
		return
		
	if current_state:
		current_state.exit()
	current_state = new_state
	new_state.enter()
	state_label.text = current_state.name
	print("entering state" + new_state_name)
