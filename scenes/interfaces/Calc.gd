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
 
