extends Area2D
signal hit
var alive = true

export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
# Add this variable to hold the clicked position.
var target = Vector2()
var velocity = Vector2()
var screenTouched = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not alive:
		return
	
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

	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	$AnimatedSprite.update_movement_animation(velocity)

func _on_Player_body_entered(_body):
	emit_signal("hit")
	die()

func die():
	alive = false
	$AnimatedSprite.death_animation()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	alive = true
	$AnimatedSprite.start()
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


func _on_AnimatedSprite_death_complete():
	hide() # Player disappears after being hit.
