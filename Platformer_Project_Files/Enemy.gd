extends KinematicBody2D

const GRAVITY = 30
var speed = 200
const FLOOR = Vector2(0, -1)
var velocity = Vector2()
var direction = 1


func _ready():
	pass

func _physics_process(delta):
	velocity.x = speed * direction
	if direction == 1:
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.flip_h = true
		
	$AnimatedSprite.play("walk")
	
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, FLOOR)
	
	
	
	if is_on_wall():
		direction = direction * -1
		$RayCast2D.position.x *= -1
	if $RayCast2D.is_colliding() == false:
		direction = direction * -1
		$RayCast2D.position.x *= -1
	
