extends Resource

@export var total_jumps: int = 0
@export var total_deaths: int = 0
## The ID for the latest unlocked level. Just keep incrementing this
## according to the total levels completed
@export var level_unlocked: int = 0

@export var best_time: float = -1

func save_game():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var data_dict = {
		"best_time": best_time,
		"total_deaths": total_deaths,
		"total_jumps": total_jumps,
		"level_unlocked": level_unlocked
	}
	
	save_file.store_line(JSON.stringify(data_dict))
	
	print("SAVE")
	print(str(data_dict))
	

func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	# Creates the helper class to interact with JSON
	var json = JSON.new()
	var json_string = save_file.get_line()
	# Check if there is any error while parsing the JSON string, skip in case of failure
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return

	# Get the data from the JSON object
	# AWFUL CODE
	var node_data = json.get_data()
	total_jumps = node_data["total_jumps"]
	total_deaths = node_data["total_deaths"]
	level_unlocked = node_data["level_unlocked"]
	best_time = node_data["best_time"]
	
	print("LOAD")
	print(node_data)
