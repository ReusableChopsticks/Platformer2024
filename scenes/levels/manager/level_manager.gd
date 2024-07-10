extends Node
class_name LevelManager

## Array of the file names of each level scene (without file extension)
@export var levels: Array[String]
var levels_file_path: String = "res://scenes/levels/"
## The index of the level the player is currently on
var current_level_num: int = 0
## The level the player is currently on
var current_level: Level

func load_current_level():
	if current_level:
		current_level.queue_free()
	
	## for now, we loop back around to the start on the last level
	if current_level_num >= levels.size():
		print("LAST LEVEL REACHED: LOOPING BACK TO THE FIRST LEVEL")
		current_level_num = 0
	
	var level_path = "%s%s.tscn" % [levels_file_path, levels[current_level_num]]
	current_level = load(level_path).instantiate()
	current_level.level_completed.connect(on_level_completed)
	add_child(current_level)
	#get_tree().change_scene_to_file(level_path)
	
	
func _ready():
	load_current_level()
	
func on_level_completed(level_name):
	print("Just completed level: %s" % level_name)
	current_level_num += 1
	call_deferred("load_current_level")
