extends CanvasLayer


@onready var level_manager: LevelManager = $"../LevelManager"
@onready var tree: Tree = $MarginContainer/Tree

# Called when the node enters the scene tree for the first time.
func _ready():
	var level_index := 0
	var world_index := 0
	var root = tree.create_item()
	tree.hide_root = true
	for world in level_manager.worlds:
		world_index += 1
		var world_leaf = tree.create_item(root)
		world_leaf.set_text(0, "World %s" % str(world_index))
		
		for level in world:
			level_index += 1
			var level_leaf = tree.create_item(world_leaf)
			# we have to instantiate the level node to get its name *crying emoji*
			var level_node: Level = level.instantiate()
			level_leaf.set_text(0, "%s: %s" % [str(level_index), level_node.name])
			level_node.queue_free()
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
