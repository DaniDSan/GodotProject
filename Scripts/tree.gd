extends Area2D

var DentroIzq = false
var DentroDer = false
var DentroArriba = false
var DentroAbajo = false

var TroncoSpawnAbierto = false

var TiempoRespawn = false


@export var Tronco: PackedScene

var rng = RandomNumberGenerator.new()

var VidaTree = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("TreeStay")  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if VidaTree!=0:
		TroncoSpawnAbierto=false
		if DentroIzq==true:
			if Input.is_action_pressed("interactuar"):
				VidaTree -= 1
				$AnimatedSprite2D.play("TreeHit")
				$AnimatedSprite2D.flip_h=true
			if Input.is_action_just_released("interactuar"):
				$AnimatedSprite2D.play("TreeStay")
				$AnimatedSprite2D.flip_h=false
				
		if DentroDer == true:
			if Input.is_action_pressed("interactuar"):
				VidaTree -= 1
				$AnimatedSprite2D.play("TreeHit")
			else:
				$AnimatedSprite2D.play("TreeStay")
				
		if DentroArriba==true:
			if Input.is_action_pressed("interactuar"):
				VidaTree -= 1
				$AnimatedSprite2D.play("TreeHit")
				$AnimatedSprite2D.flip_h=true
			else:
				$AnimatedSprite2D.play("TreeStay")
				$AnimatedSprite2D.flip_h=false
			
		if DentroAbajo==true:
			if Input.is_action_pressed("interactuar"):
				VidaTree -= 1
				$AnimatedSprite2D.play("TreeHit")
			else:
				$AnimatedSprite2D.play("TreeStay")
	else:
		$AnimatedSprite2D.play("TreeChopped")
		$AnimatedSprite2D.flip_h=false
		if TiempoRespawn==false:
			TiempoRespawn=true
			$TreeRespawn.start()
		if TroncoSpawnAbierto==false:
			SpawnTronco()
			TroncoSpawnAbierto=true

func SpawnTronco():
	var TroncoTemp = Tronco.instantiate()
	var NumeroAzar = rng.randi_range(1,4)
	
	add_child(TroncoTemp)
	if NumeroAzar==1:
		TroncoTemp.position.x = $TreeCollisionRight.position.x + 10 + rng.randf_range(0,50)
		TroncoTemp.position.y = ($AnimatedSprite2D/RigidBody2D/RigidCollisionTree.position.y) + rng.randf_range(-30,30)
	if NumeroAzar==2:
		TroncoTemp.position.x = $TreeCollisionLeft.position.x - 10 + rng.randf_range(-50,0)
		TroncoTemp.position.y = ($AnimatedSprite2D/RigidBody2D/RigidCollisionTree.position.y) + rng.randf_range(-30,30)
	if NumeroAzar==3:
		TroncoTemp.position.x = rng.randf_range(-50,50)
		TroncoTemp.position.y = ($AnimatedSprite2D/RigidBody2D/RigidCollisionTree.position.y) - $TreeCollisionUp.position.y + rng.randf_range(-30,0)
	if NumeroAzar==4:
		TroncoTemp.position.x = rng.randf_range(-50,50)
		TroncoTemp.position.y = $TreeCollisionDown.position.y + rng.randf_range(0,30)

func _on_body_entered(body):
	# Entra Colisión : Left
	if body.position.x < (global_position.x + $TreeCollisionLeft.position.x):
		DentroIzq = true
	# Entra Colisión : Right
	if body.position.x > (global_position.x  + $TreeCollisionRight.position.x):
		DentroDer = true
	# Entra Colisión : Up
	if body.position.y < (global_position.y + $TreeCollisionUp.position.y):
		DentroArriba = true
	# Entra Colisión : Down
	if body.position.y > (global_position.y + $TreeCollisionDown.position.y):
		DentroAbajo = true


func _on_body_exited(body):
	$AnimatedSprite2D.play("TreeStay")
	# Salida Colisión : Left
	if body.position.x < (global_position.x + $TreeCollisionLeft.position.x):
		DentroIzq = false
	# Salida Colisión : Right
	if body.position.x > (global_position.x + $TreeCollisionRight.position.x):
		DentroDer = false
	# Salida Colisión : Up
	if body.position.y < (global_position.y + $TreeCollisionUp.position.y):
		DentroArriba = false
	# Salida Colisión : Down
	if body.position.y > (global_position.y + $TreeCollisionDown.position.y):
		DentroAbajo = false

func _on_tree_respawn_timeout():
	TiempoRespawn=false
	VidaTree=200
	$AnimatedSprite2D.play("TreeStay")
