extends Node

@export var levels: Array[String]
@export var completed_levels: Array[bool]
var levels_file_path: String = "res://scenes/levels/"
var current_level_num: int = 0
var current_level: Level

func load_current_level():
	## TODO: for now, we loop back around to the start on the last level
	if current_level_num >= levels.size():
		print("LAST LEVEL REACHED: LOOPING BACK TO THE FIRST LEVEL")
		current_level_num = 0
	current_level = load("%s%s.tscn" % [levels_file_path, levels[current_level_num]]).instantiate()
	

func _ready():
	load_current_level()
	add_child(current_level)
	current_level.level_completed.connect(on_level_completed)

func on_level_completed(name):
	print(name)
	remove_child(current_level)
	current_level_num += 1
	load_current_level()
	add_child(current_level)	
	
