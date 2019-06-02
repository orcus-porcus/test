extends KinematicBody2D

# **************Variables**************************
const UP = Vector2(0, -1)
var motion = Vector2()
export var max_speed = 300
export var gravity = 30
var acceleration = 50
export var jump_force =-800

var on_ground = false
var is_attacking

const FIREBALL = preload("res://Fireball.tscn") # preload in memory Fireball Object(Scene)

#onready var timer = get_node("Timer")
	
#************** Motion Control **********************


func _physics_process(delta):
	motion.y += gravity
	var friction = false
	
	if Input.is_action_pressed("MoveRight"):
		if is_attacking == false or is_on_floor() == false:
			motion.x = min(motion.x + acceleration, max_speed) #if motion.x+acceleration is higher then max_speed -> set it to max_speed
			if is_attacking == false:
				$Sprite.flip_h = false # if true, texture is flipped horizontally / flip_v is flipped vertically
				$Sprite.play("run") # play the run animation from node Sprite 
				if sign($Position2D.position.x) == -1:
					$Position2D.position.x *= -1
	elif Input.is_action_pressed("MoveLeft"):
		if is_attacking == false or is_on_floor() == false:
			motion.x = max(motion.x - acceleration, -max_speed)
			if is_attacking == false:
				$Sprite.flip_h = true
				$Sprite.play("run")
				if sign($Position2D.position.x) == 1:
					$Position2D.position.x *= -1
	else:
		if on_ground == true && is_attacking == false:
			friction = true
			$Sprite.play("idle")
		
	if Input.is_action_just_pressed("Jump"):
		if is_attacking == false:
			if on_ground == true:
				motion.y = jump_force
				on_ground = false

			
#******************** Fireball ******************************
	if Input.is_action_just_pressed("Fire") && is_attacking == false:
		if is_on_floor():
			motion.x = 0 # if on floor while attacking he stopps
		is_attacking = true		
		$Sprite.play("attack")
		var fireball = FIREBALL.instance() # create an instance of object fireball every time the key is released
		if sign($Position2D.position.x) == 1: # flipps Position2D to the right of our player if positiv 1 or left if -1
			fireball.set_fireball_direction(1) # sets direction in which fireball flyes, positiv 1 right
		else:
			fireball.set_fireball_direction(-1) # or sets flying direction of fireball to left if -1
			
		get_parent().add_child(fireball) # get_parent in this case which level the player is and create there an fireball instance
		fireball.position = $Position2D.global_position	 #declare where fireball is spawned in this case where we put the Position2D Node
	
#*************************************************************
		
		
	if is_on_floor():
		if on_ground == false:
			is_attacking = false
		on_ground = true
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.7) # slow down from value of motion.x to 0 every tick for 0.2 (20%) 0.3 (30%)
	else:
		if is_attacking == false:
			on_ground = false
			if motion.y < 0 :
				$Sprite.play("jump")
			else:
				$Sprite.play("fall")
			if friction == true:
				motion.x = lerp(motion.x, 0, 0.05)

			
			
			
	motion = move_and_slide(motion, UP)


func _on_Sprite_animation_finished():
	is_attacking = false
