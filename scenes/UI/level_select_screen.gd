extends CanvasLayer


@onready var level_manager: LevelManager = $"../LevelManager"
@onready var tree: Tree = $MarginContainer/Tree

@export var button_texture: Texture2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var level_index := 0
	var world_index := 0
	var root: TreeItem = tree.create_item()
	
	tree.hide_root = true
	for world in level_manager.worlds:
		world_index += 1
		var world_leaf: TreeItem = tree.create_item(root)
		world_leaf.set_text(world_index, "World %s" % str(world_index))
		
		for level in world:
			level_index += 1
			var level_leaf: TreeItem = tree.create_item(world_leaf)
			# we have to instantiate the level node to get its name *crying emoji*
			var level_node: Level = level.instantiate()
			level_leaf.set_text(0, "%s: %s" % [str(level_index), level_node.name])
			level_leaf.add_button(0, button_texture, level_index - 1)
			level_node.queue_free()
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_tree_button_clicked(item, column, id, mouse_button_index):
	print("%s %s" % [str(column), str(id)])
