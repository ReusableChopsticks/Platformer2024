extends CanvasLayer


@export var tree: Tree
@export var button_texture: Texture2D

@onready var level_manager: LevelManager = $"../LevelManager"
var player_stats: Resource = preload("res://scenes/player/PlayerStats.tres")

signal back_pressed

func _ready():
	create_tree()

func _on_visibility_changed():
	if visible == true:
		create_tree()

## Creates and refreshes tree
func create_tree():
	tree.grab_focus()
	tree.clear()
	var level_index := 0
	var world_index := 0
	var root: TreeItem = tree.create_item()
	tree.hide_root = true
	
	## A tree of worlds and levels
	## Each level lead has a button with an id corresponding to level num
	for world in level_manager.worlds:
		world_index += 1
		var world_leaf: TreeItem = tree.create_item(root)
		world_leaf.set_text(0, "World %s" % str(world_index))
		
		for level in world:
			level_index += 1
			var level_leaf: TreeItem = tree.create_item(world_leaf)
			if level_index - 1 > player_stats.level_unlocked:
				level_leaf.set_text(0, "LOCKED")
			else:
				# we have to instantiate the level node to get its name 
				# *insert crying emoji*
				var level_node: Level = level.instantiate()
				level_leaf.set_text(0, "%s: %s" % [str(level_index), level_node.name])
				level_leaf.add_button(0, button_texture, level_index - 1)
				level_node.queue_free()

## When you click play on a level
func _on_tree_button_clicked(item, column, id, mouse_button_index):
	#print("%s %s" % [str(column), str(id)])
	## Figure out the world and level index for that world
	## a level is in based on its ID
	var i = 0
	var world_index = 0
	while i + level_manager.worlds[world_index].size() <= id:
		i += level_manager.worlds[world_index].size()
		world_index += 1
	
	#print("WORLD: %s     id: %s" % [str(world_index), str(id)])
	
	level_manager.load_level(world_index, id - i)
	AudioManager.clair_de_lune.play()
	visible = false


func _on_back_button_pressed():
	back_pressed.emit()

