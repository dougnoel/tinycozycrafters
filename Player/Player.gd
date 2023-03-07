extends CharacterBody2D
signal hit
@export var speed = 150 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
# Add this variable to hold the clicked position.
var target = Vector2()
var screenTouched = false

enum State {
	MOVE,
	ATTACK,
	DEAD,
	IN_ANIMATION,
}

var state = State.MOVE

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	match state:
		State.DEAD, State.IN_ANIMATION:
			return
		State.MOVE:
			move()
		State.ATTACK:
			attack()

func _on_Player_body_entered(_body):
	emit_signal("hit")
	die()

func die():
	state = State.DEAD
	$SoundEffect.play_sound("Death")
	$AnimatedSprite2D.death_animation()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)

func start():
	hide()
	state = State.MOVE
	$AnimatedSprite2D.start()
	position = Vector2(screen_size.x/2,screen_size.y/2)
	# Initial target is the start position.
	target = position
	show()
	$CollisionShape2D.disabled = false

# Change the target whenever a touch event happens.
func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		target = event.position
		screenTouched = true

func process_player_input():
		#Keyboard Input
	velocity.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	velocity.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	#Mouse/Touchscreen Input
	if screenTouched:
		# Move towards the target and stop when close.
		if position.distance_to(target) > 10:
			velocity = target - position
		else:
			screenTouched = false
	
	if Input.is_action_just_pressed("attack"):
		state = State.ATTACK

## Prevents the Player from exiting the screen.
##calculated based on the current screen size for use on different platforms.
func clamp_player():
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
## We only want sounde effects playing once
func _on_SoundEffect_finished():
	$SoundEffect.stop()

func move():
	process_player_input() #Moving this so we can use the same code for mobs
	
	velocity = velocity.normalized() * speed
	set_velocity(velocity)
	move_and_slide()
	velocity = velocity
	
	clamp_player() #Prevent the Player from leaving the screen

	$AnimatedSprite2D.update_movement_animation(velocity)

func attack():
	$AnimatedSprite2D.attack_animation()
	state = State.IN_ANIMATION

func _attack_complete():
	state = State.MOVE
