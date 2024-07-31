extends CharacterBody2D

const max_speed = 200
const accel = 3000
const friction = 2000

var input = Vector2.ZERO
var facing
var CanDash = true
var CooldownDash = false

signal andarSound
signal dashSound

func _physics_process(delta):
	player_movement(delta)
	dash()
	walkAni()


func get_input():
	if CanDash == true:
		input.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
		input.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return input.normalized()


func player_movement(delta):
	input = get_input()
	if input == Vector2.ZERO and CanDash==true:
		if velocity.length() > (friction * delta):
			velocity -= velocity.normalized() * (friction * delta)
		else:
			velocity = Vector2.ZERO
	if not input == Vector2.ZERO and CanDash==true:
		velocity += (input * accel * delta)
		velocity = velocity.limit_length(max_speed)
	move_and_slide()
	
	if Input.is_action_pressed("ui_right")==true:
		facing = "right"
	if Input.is_action_pressed("ui_left")==true:
		facing = "left"
	if Input.is_action_pressed("ui_down")==true: 
		facing = "down"
	if Input.is_action_pressed("ui_up")==true: 
		facing = "up"
	if Input.is_action_pressed("ui_right")==true and Input.is_action_pressed("ui_down")==true:
		facing = "right/down"
	if Input.is_action_pressed("ui_right")==true and Input.is_action_pressed("ui_up")==true:
		facing = "right/up"
	if Input.is_action_pressed("ui_left")==true and Input.is_action_pressed("ui_up")==true:
		facing = "left/up"
	if Input.is_action_pressed("ui_left")==true and Input.is_action_pressed("ui_down")==true:
		facing = "left/down"


func dash():
	
	if Input.is_action_just_pressed("dash") and facing=="right" and CanDash==true and CooldownDash==false:
		velocity.x =  velocity.x + 350
		$DashCooldown.start()
		$ActualDashCooldown.start()
		CooldownDash=true
		CanDash = false
		$AnimatedSprite2D.play("golpeDerecha")
	
	if Input.is_action_just_pressed("dash") and facing=="left" and CanDash==true and CooldownDash==false:
		velocity.x =  velocity.x - 350
		$DashCooldown.start()
		$ActualDashCooldown.start()
		CooldownDash=true
		CanDash = false
	
	if Input.is_action_just_pressed("dash") and facing=="down" and CanDash==true and CooldownDash== false:
		velocity.y =  velocity.y + 350
		$DashCooldown.start()
		$ActualDashCooldown.start()
		CooldownDash=true
		CanDash = false
	if Input.is_action_just_pressed("dash") and facing=="up" and CanDash==true and CooldownDash== false:
		velocity.y =  velocity.y - 350
		$DashCooldown.start()
		$ActualDashCooldown.start()
		CooldownDash=true
		CanDash = false
	
	if Input.is_action_just_pressed("dash") and facing=="right/down" and CanDash==true and CooldownDash== false:
		velocity.y =  velocity.y + 247.4873
		velocity.x =  velocity.x + 247.4873
		$DashCooldown.start()
		$ActualDashCooldown.start()
		CooldownDash=true
		CanDash = false
		
	if Input.is_action_just_pressed("dash") and facing=="right/up" and CanDash==true and CooldownDash== false:
		velocity.y =  velocity.y - 247.4873
		velocity.x =  velocity.x + 247.4873
		$DashCooldown.start()
		$ActualDashCooldown.start()
		CooldownDash=true
		CanDash = false
		
	if Input.is_action_just_pressed("dash") and facing=="left/up" and CanDash==true and CooldownDash== false:
		velocity.y =  velocity.y - 247.4873
		velocity.x =  velocity.x - 247.4873
		$DashCooldown.start()
		$ActualDashCooldown.start()
		CooldownDash=true
		CanDash = false
		
	if Input.is_action_just_pressed("dash") and facing=="left/down" and CanDash==true and CooldownDash== false:
		velocity.y =  velocity.y + 247.4873
		velocity.x =  velocity.x - 247.4873
		$DashCooldown.start()
		$ActualDashCooldown.start()
		CooldownDash = true
		CanDash = false

func _on_dash_cooldown_timeout():
	CanDash = true # Replace with function body.

func _on_actual_dash_cooldown_timeout():
	CooldownDash=false

func walkAni():
	if velocity == Vector2.ZERO:
		$AnimatedSprite2D.play("stay")

	if velocity!=Vector2.ZERO and CanDash==true:
		$AnimatedSprite2D.play("walk")
		if facing=="right" or facing=="right/up" or facing=="right/down":
			$AnimatedSprite2D.flip_h = false
			$Hand.position.x = 32.61
		if facing=="left" or facing=="left/up" or facing=="left/down":
			$AnimatedSprite2D.flip_h = true
			$Hand.position.x = -32.61


	if CanDash==false:
		if facing=="right" or facing=="right/up" or facing=="right/down" or facing=="left" or facing=="left/up" or facing=="left/down":
			$AnimatedSprite2D.play("golpeDerecha")
		if facing=="up":
			$AnimatedSprite2D.flip_h=false
			$AnimatedSprite2D.play("golpeArriba")
		if facing=="down":
			$AnimatedSprite2D.flip_h=false
			$AnimatedSprite2D.play("golpeAbajo")
			
func _on_animated_sprite_2d_frame_changed():
	if $AnimatedSprite2D.animation=="walk":
		if $AnimatedSprite2D.frame==0 or $AnimatedSprite2D.frame==3:
			andarSound.emit() # Replace with function body.
	if $AnimatedSprite2D.animation=="golpeDerecha" or $AnimatedSprite2D.animation=="golpeArriba" or $AnimatedSprite2D.animation=="golpeAbajo":
		if $AnimatedSprite2D.frame==0:
			dashSound.emit()
