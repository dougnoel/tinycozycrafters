extends AnimatedSprite
signal death_complete
var facing = "right"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func start():
	facing = "right"
	animation = "idle right"
	play()
	
func update_movement_animation(velocity: Vector2):
	var animation_name
	
	# Set the facing if it needs to change
	if velocity.x > 0:
		facing = "right"
	elif velocity.x < 0:
		facing = "left"
	
	# Determine if we are moving or not
	if velocity.x == 0 and velocity.y == 0:
		animation_name = "idle"
	else:
		animation_name = "walk"
	
	# The space is added between the two items here so that we don't risk a typo somewhere else
	animation = animation_name + " " + facing
	print(animation)

func death_animation():
	animation = "death " + facing

func _on_AnimatedSprite_animation_finished():
	if "death" in animation:
		stop()
		emit_signal("death_complete")
