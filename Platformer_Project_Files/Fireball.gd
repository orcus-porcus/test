extends Area2D

var speed = 500
var velocity = Vector2()
var direction = 1
var fireball_explosion = false

func _ready():
	pass # Replace with function body.

func set_fireball_direction(dir):
	direction = dir
	if dir == -1:
		$AnimatedSprite.flip_v = true



func _physics_process(delta):
	velocity.x = speed * delta * direction
	translate(velocity)
	if fireball_explosion == false:
		$AnimatedSprite.play("fireball")
	else:
		speed = 0
		$AnimatedSprite.play("fireball_hit")

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	
	
func _on_Fireball_body_entered(body):
	fireball_explosion = true
	#$AnimatedSprite.stop()
	#$AnimatedSprite.play("fireball_hit")
	#yield(get_tree().create_timer(5.5),"timeout")
	
	
func _on_AnimatedSprite_animation_finished():
	if fireball_explosion == true:
		queue_free()
