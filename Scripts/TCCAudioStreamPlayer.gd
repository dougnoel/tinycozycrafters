## A simple script that allows you to set or play a sound from a list of
## Sound nodes.
extends AudioStreamPlayer
var currentSoundName = ""

func play_sound(var node):
	if node is float:
		play(node)
	else:
		set_sound(node)
		play()

## Sets a sound 
func set_sound(var node):
	if node is String:
		node = get_node(str(node))
	set_stream(node.stream)
	currentSoundName = node.name

## Returns the Node name of the current sound that is set, whether
## it is currently playing or not.
func get_sound():
	return currentSoundName

func _mute():
	set_volume_db(-80)

func _unmute():
	set_volume_db(0)
