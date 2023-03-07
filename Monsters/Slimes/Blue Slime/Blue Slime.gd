extends RigidBody2D
var velocity = Vector2()
@onready var sprite = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	velocity = get_linear_velocity()
	sprite.update_movement_animation(velocity)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
