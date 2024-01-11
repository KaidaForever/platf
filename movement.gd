extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var ISFACINGRIGHT = true

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	
	
	# Handle jump.
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	# Rotate player sprite to direction you're moving
	if direction != 0:
		$Sprite2D.flip_h = (direction == -1)
	
	animate(direction)

	move_and_slide()
		
func animate(direction):
	if is_on_floor():
		if direction == 0:
			$AnimationPlayer.play("idle")
		else:
			$AnimationPlayer.play("run")
	else :
		if velocity.y < -100:
			$AnimationPlayer.play("jump")
		elif velocity.y > 100:
			$AnimationPlayer.play("fall")
		else:
			$AnimationPlayer.play("levitate")
