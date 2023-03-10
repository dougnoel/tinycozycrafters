extends Node
@export var slime_scene: PackedScene
var startPosition: Marker2D
var score
#onready var level = get_node("Level 1")
@onready var player = get_node("Level 1").get_node("Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$Music.play_sound($Music/OpeningMusic)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Player_hit():
	game_over()

func game_over():
	$Music.play_sound("GameOver")
	$ScoreTimer.stop()
	$SlimeTimer.stop()
	$HUD.show_game_over()

func new_game():
	$Music.play_sound("PrairieMusic")
	score = 0
	player.start()
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("slimes", "queue_free")

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_StartTimer_timeout():
	$SlimeTimer.start()
	$ScoreTimer.start()

func _on_SlimeTimer_timeout():
	# Create a new instance of the Blue Slime scene.
	var slime = slime_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("SlimePath/SlimeSpawnLocation")
	mob_spawn_location.set_progress(randi())

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	slime.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
#	slime.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(75.0, 125.0), 0.0)
	slime.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(slime)

func _on_Music_finished():
	if $Music.get_sound() == "GameOver":
		$Music.play_sound("OpeningMusic")
