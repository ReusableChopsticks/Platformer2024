extends Node
class_name LevelManager

## For testing
@export var start_level_index: int = 0
@export var start_world_index: int = 0
## Array of the file names of each level scene (without file extension)
@export var world_1: Array[PackedScene]
@export var world_2: Array[PackedScene]


## Array of world arrays
@onready var worlds := [world_1, world_2]
## The index of the level the player is currently on
## in the world they are in. i.e., the value of this
## for level 1 of world 2 would still be 0. 
var level_index: int = 0
var world_index: int = 0
## The level the player is currently on
var current_level: Level
## How many levels player has completed
var levels_completed_count := 0

var completion_time: float = 0

func _ready():
	# subtract one so when calling load_next_level, it loads the current one
	level_index = start_level_index - 1
	world_index = start_world_index
	load_next_level()

func load_current_level():
	## Unload the current level
	if current_level:
		current_level.queue_free()
	
	## If last world's level completed, move on to the next world
	if level_index >= worlds[world_index].size():
		print("LAST LEVEL REACHED: MOVING TO NEXT WORLD")
		world_index += 1
		level_index = 0
	
	if quit_if_empty():
		get_tree().quit()
		return
	
	print(str(world_index) + " " + str(level_index))
	
	current_level = worlds[world_index][level_index].instantiate()
	current_level.level_completed.connect(on_level_completed)
	add_child(current_level)

func load_next_level():
	level_index += 1
	levels_completed_count += 1
	load_current_level()

func load_level(world_index: int, level_index: int):
	self.world_index = world_index
	self.level_index = level_index
	load_current_level()
	

func quit_if_empty():
	if world_index >= worlds.size():
		print("Last level completed")
		return true
	elif not worlds[world_index][level_index]:
		print("Level %s in world %s is not assigned in LevelManager" % [str(level_index), str(world_index)])
		return true
	return false
	

func on_level_completed(level_name):
	print("Just completed level: %s" % level_name)
	call_deferred("load_next_level")
