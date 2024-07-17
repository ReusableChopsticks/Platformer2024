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
	
	var total_sec = milliseconds / 1000.0
	var min = total_sec / 60
	var sec = total_sec - (total_sec / 60.0)
	return "%sm %ss"
