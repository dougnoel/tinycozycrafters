extends Area2D
signal hit

export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
# Add this variable to hold the clicked position.
var target = Vector2()
var velocity = Vector2()
var screenTouched = false
var facing = "right"

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
#	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if screenTouched:
		velocity = Vector2()
		# Move towards the target and stop when close.
		if position.distance_to(target) > 10:
			velocity = target - position
		else:
			screenTouched = false
	else:
		velocity = Vector2.ZERO # The player's movement vector.
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	$AnimatedSprite.play()

	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	change_animation()

func _on_Player_body_entered(body):
	hide() # Player disappears after being hit.
	emit_signal("hit")
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	# Initial target is the start position.
	target = pos
	show()
	$CollisionShape2D.disabled = false

# Change the target whenever a touch event happens.
func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		target = event.position
		screenTouched = true

func change_animation():
	var animation
	
	# Set the facing if it needs to change
	if velocity.x > 0:
		facing = "right"
	elif velocity.x < 0:
		facing = "left"
	
	# Determine if we are moving or not
	if velocity.x == 0 and velocity.y == 0:
		animation = "idle"
	else:
		animation = "walk"
	
	# The space is added between the two items here so that we don't risk a typo somewhere else
	$AnimatedSprite.animation = animation + " " + facing
