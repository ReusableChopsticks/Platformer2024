extends Node2D
class_name Level

## The base level node
## new levels must contain a player and a goal
## level node is responsible for instantiating a new player for respawning

signal level_completed

@onready var player: PlayerCharacter = get_node("Player")
var player_spawn_pos: Vector2
var player_scene = preload("res://scenes/player/player.tscn")

func _ready():
	player = get_node("Player")
	player_spawn_pos = player.position
	player.player_died.connect(on_player_died)

## Handle player respawning
func on_player_died():
	call_deferred("on_player_died_deferred")

func on_player_died_deferred():
	player.queue_free()
	var new_player = player_scene.instantiate()
	new_player.position = player_spawn_pos
	add_child(new_player)
	
