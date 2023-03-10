extends CanvasLayer

signal start_game
signal mute
signal unmute

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	$Message.text = "Tiny Cozy Crafters"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1).timeout
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)

func _on_MessageTimer_timeout():
	$Message.hide()

func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")

func _on_PauseMenu_mute():
	emit_signal("mute")

func _on_PauseMenu_unmute():
	emit_signal("unmute")
