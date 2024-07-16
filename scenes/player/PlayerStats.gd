extends Resource

@export var total_jumps: int = 0
## The ID for the latest unlocked level. Just keep incrementing this
@export var latest_level_unlocked: int = 0

# really just a test to see how custom resources work
func _init(p_total_jumps = 0):
	total_jumps = p_total_jumps
