extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var ISFACINGRIGHT = true

var ISCROUCHING

func _physics_process(delta):

	if not is_on_floor():
		velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_pressed("move_crouch") and is_on_floor():
		ISCROUCHING = true
	else:
		ISCROUCHING = false

	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if direction != 0:
		$Sprite2D.flip_h = (direction == -1)
	
	animate(direction)

	move_and_slide()
		
func animate(direction):
	if ISCROUCHING:
		if direction != 0:
			$AnimationPlayer.play("crouch_walk")
		else:
			$AnimationPlayer.play("crouch_idle")
	else:
		if is_on_floor():
			if direction == 0:
				$AnimationPlayer.play("idle")
			else:
				$AnimationPlayer.play("run")
		else:
			if velocity.y < -100:
				$AnimationPlayer.play("jump")
			elif velocity.y > 100:
				$AnimationPlayer.play("fall")
			else:
				$AnimationPlayer.play("levitate")
