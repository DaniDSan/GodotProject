extends CharacterBody2D

func _physics_process(_delta):
	velocity = global_transform.x * 800
	move_and_slide()
