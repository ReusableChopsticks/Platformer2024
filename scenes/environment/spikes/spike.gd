extends Area2D


func _on_body_entered(body):
	## check if body entered is player
	## and player has not already died
	## because player may touch multiple spikes at once
	if body is PlayerCharacter and !body.has_died :
		body.die()
