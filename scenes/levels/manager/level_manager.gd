extends Node
class_name LevelManager

## For testing
@export var start_level_index: int = 0
## Array of the file names of each level scene (without file extension)
@export var levels: Array[PackedScene]
#var levels_file_path: String = "res://scenes/levels/"
## The index of the level the player is currently on
var current_level_index: int = 0
## The level the player is currently on
var current_level: Level

func load_current_level():
	if current_level:
		current_level.queue_free()
	
	## for now, we loop back around to the start on the last level
	if current_level_index >= levels.size():
		print("LAST LEVEL REACHED: LOOPING BACK TO THE FIRST LEVEL")
		current_level_index = 0
	
	#var level_path = "%s%s.tscn" % [levels_file_path, levels[current_level_index]]
	if not levels[current_level_index]:
		get_tree().quit()
		return
	
	current_level = levels[current_level_index].instantiate()
	current_level.level_completed.connect(on_level_completed)
	add_child(current_level)
	#get_tree().change_scene_to_file(level_path)
	
	
func _ready():
	current_level_index = start_level_index
	load_current_level()
	print(levels)
	
func on_level_completed(level_name):
	print("Just completed level: %s" % level_name)
	current_level_index += 1
	call_deferred("load_current_level")
