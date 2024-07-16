extends Node2D
class_name Level

## The base level node
## new levels must contain a player and a goal
## level node is responsible for instantiating a new player for respawning

signal level_completed
signal player_respawned

@onready var player: PlayerCharacter = $Player
var player_spawn_pos: Vector2
var player_scene = preload("res://scenes/player/player.tscn")


func _ready():
	player = get_node("Player")
	player_spawn_pos = player.position
	player.player_died.connect(on_player_died)
	$LevelName.text = name

## Handle player respawning
func on_player_died():
	call_deferred("respawn_player")

func respawn_player():
	player.queue_free()
	player = player_scene.instantiate()
	player.position = player_spawn_pos
	player.player_died.connect(on_player_died)	
	add_child(player)
	player_respawned.emit()
