extends RigidBody2D
var velocity = Vector2()
var animation = "idle"
var facing = "right"

const DIRECTION_NONE = 0
const DIRECTION_RIGHT = 1
const DIRECTION_UP = 2
const DIRECTION_LEFT = 3
const DIRECTION_DOWN = 4


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.playing = true
	change_animation()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func change_animation():
	velocity = get_linear_velocity()
		
	# Set the facing if it needs to change
	if velocity.y > 0:
		facing = "down"
	elif velocity.y < 0:
		facing = "up"
		
	if velocity.x > 0 and velocity.y:
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
