extends AnimatedSprite2D
signal death_complete
signal attack_complete

enum Facing {
	RIGHT,
	LEFT,
	UP,
	DOWN,
}

enum SpriteType {
	LEFT_ONLY,
	RIGHT_ONLY,
	LEFT_AND_RIGHT,
	LEFT_RIGHT_UP_AND_DOWN,
}

@export var sprite_type: SpriteType = SpriteType.LEFT_RIGHT_UP_AND_DOWN
@export var initial_facing: Facing = Facing.RIGHT
var facing = get_facing()

func start():
	facing = get_facing()
	animation = "idle right"
	play()
	
func update_movement_animation(velocity: Vector2):
	var animation_name
	
	# Set the facing if it needs to change
	if sprite_type == SpriteType.LEFT_RIGHT_UP_AND_DOWN:
		if velocity.y > 0:
			facing = "down"
		elif velocity.y < 0:
			facing = "up"
	
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

func death_animation():
	animation = "death " + facing
	
func attack_animation():
	animation = "attack " + facing
	play()

func _on_AnimatedSprite_animation_finished():
	if "death" in animation:
		play(animation, true) # Plays the animation in reverse so that the last frame is played again
		stop() # Halts the animation. Doing this after playing in reverse prevents the character from "standing up".
		emit_signal("death_complete")
	if "attack" in animation:
		stop()
		emit_signal("attack_complete")

func get_facing():
	var face = Facing.keys()[initial_facing]
	return face.to_lower()
	
