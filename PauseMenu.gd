extends Control
signal mute
signal unmute

var is_paused = false : set = set_is_paused

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		self.is_paused = !is_paused

func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused

func _on_Music_Button_toggled(button_pressed):
	if button_pressed:
		emit_signal("mute")
		$CenterContainer/VBoxContainer/MusicMuteButton.text = "Music: Off"
	else:
		emit_signal("unmute")
		$CenterContainer/VBoxContainer/MusicMuteButton.text = "Music: On"

func _on_ResumeGameButton_pressed():
	self.is_paused = false

func _on_QuitButton_pressed():
	get_tree().quit()
