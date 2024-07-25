extends Node
class_name LevelManager

## For testing
@export var start_level_index: int = 0
@export var start_world_index: int = 0
## Array of the file names of each level scene (without file extension)
@export var world_1: Array[PackedScene]
@export var world_2: Array[PackedScene]

var endscreen = preload("res://scenes/UI/end_screen.tscn")
# the instantiated endscreen scene
var endscreen_node = null
var player_stats: Resource = preload("res://scenes/player/PlayerStats.tres")

## Array of world arrays
@onready var worlds := [world_1, world_2]
## The index of the level the player is currently on
## in the world they are in. i.e., the value of this
## for level 1 of world 2 would still be 0. 
var level_index: int = 0
var world_index: int = 0
## The level the player is currently on
var current_level: Level
## The total amount of levels, calculated in the ready function
var total_level_count := 0

## -1 signifies invalid time and is checked in time calculations
var start_time: int = -1
var end_time: int = -1
var completion_time := -1

signal quit_level

func _ready():
	level_index = start_level_index
	world_index = start_world_index
	for world in worlds:
		total_level_count += world.size()

func quit_to_main_menu():
	unload_current_level()
	unlock_level()

## Updates player_stats to unlock the furthest level reached so far
func unlock_level():
	player_stats.level_unlocked = max(player_stats.level_unlocked, get_current_level_id())
	

func get_current_level_id():
	var id = 0
	for i in range(world_index):
		id += worlds[i].size()
	id += level_index
	return id

func load_current_level():
	## Unload the current level
	if current_level:
		current_level.queue_free()
	
	if last_level_reached():
		show_endscreen()
		return
	
	## Reset the start time
	if start_time == -1 and level_index == 0 and world_index == 0:
		start_time = Time.get_ticks_msec()
	
	unlock_level()
	current_level = worlds[world_index][level_index].instantiate()
	current_level.level_completed.connect(on_level_completed)
	add_child(current_level)

func unload_current_level():
	if current_level:
		current_level.queue_free()
		current_level = null

func load_next_level():
	level_index += 1
	
	## If last world's level completed, move on to the next world
	if level_index >= worlds[world_index].size():
		print("LAST LEVEL REACHED: MOVING TO NEXT WORLD")
		world_index += 1
		level_index = 0
	
	load_current_level()

func load_level(load_world_index: int, load_level_index: int):
	world_index = load_world_index
	level_index = load_level_index
	
	## If player is not starting from the beginning
	if world_index != 0 and level_index != 0:
		start_time = -1
	
	load_current_level()

## Check if last level has been reached or not
func last_level_reached():
	if world_index >= worlds.size():
		print("Last level completed")
		end_time = Time.get_ticks_msec()
		completion_time = end_time - start_time
		return true
	elif not worlds[world_index][level_index]:
		print("Level %s in world %s is not assigned in LevelManager" % [str(level_index), str(world_index)])
		return true
	return false

func show_endscreen():
	unload_current_level()
	endscreen_node = endscreen.instantiate()
	add_child(endscreen_node)
	endscreen_node.quit_to_main_menu.connect(_on_endscreen_quit_level)
	## Reset player back to the start
	level_index = 0
	world_index = 0

func on_level_completed(level_name):
	#print("Just completed level: %s" % level_name)
	call_deferred("load_next_level")

func _on_pause_menu_quit_level():
	quit_level.emit()

func _on_endscreen_quit_level():
	endscreen_node.queue_free()
	endscreen_node = null
	start_time = -1
	quit_level.emit()
