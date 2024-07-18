extends Node

# Approach a value. Used in process functions.
# Step should be a positive value and multiplied by delta
func approach(start, end, step):
	# end value aleady reached
	if (is_equal_approx(start, end)):
		return end

	var direction = signf(end - start)
	var result = start + (step * direction)

	# function has gone over intended value
	if (sign(direction) != sign(end - result)):
		return end
	return result
 
func format_minutes(milliseconds: float):
	if milliseconds == -1:
		return "Not set yet!"
	
	var sec: int = int(milliseconds / 1000) % 60
	var minutes: int = int(milliseconds / (1000 * 60)) % 60
	var mil: int = int(milliseconds) % 1000
	
	return "%0*d:%0*d.%0*d" % [2, minutes, 2, sec, 4, mil]
	#return "%sm %ss %0*dms" % [str(min), str(sec), 4, mil]
