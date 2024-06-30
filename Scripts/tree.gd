extends Area2D

# Collisiones : Dentro del árbol
var DentroIzq = false
var DentroDer = false
var DentroArriba = false
var DentroAbajo = false

# Sonido : señales para sonido en el main
signal talarSound

# Respawn : Hace que aparezca SOLO 1 tronco
var TroncoSpawnAbierto = false

# Respawn : Activa el timer de respawn del Árbol
var TiempoRespawn = false

# Respawn : PackedScene del Tronco y numero aleatorios indicando la zona donde spawnean
@export var Tronco: PackedScene
var rng = RandomNumberGenerator.new()

# Estado : Si está vivo o muerto el Árbol
var VidaTree = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("TreeStay")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Estado : Si está vivo
	if VidaTree==true:
		TroncoSpawnAbierto=false
		if DentroIzq==true:
			if Input.is_action_pressed("interactuar"):
				if $TimerTalarArbol.get_time_left() == 0:
					$TimerTalarArbol.start()
				else:
					$TimerTalarArbol.paused = false
				$AnimatedSprite2D.play("TreeHit")
				$AnimatedSprite2D.flip_h=true
			if Input.is_action_just_released("interactuar"):
				$AnimatedSprite2D.play("TreeStay")
				$AnimatedSprite2D.flip_h=false
				$TimerTalarArbol.paused = true
				
		if DentroDer == true:
			if Input.is_action_pressed("interactuar"):
				if $TimerTalarArbol.get_time_left() == 0:
					$TimerTalarArbol.start()
				else:
					$TimerTalarArbol.paused = false
				$AnimatedSprite2D.play("TreeHit")
			if Input.is_action_just_released("interactuar"):
				$AnimatedSprite2D.play("TreeStay")
				$TimerTalarArbol.paused = true
				
		if DentroArriba==true:
			if Input.is_action_pressed("interactuar"):
				if $TimerTalarArbol.get_time_left() == 0:
					$TimerTalarArbol.start()
				else:
					$TimerTalarArbol.paused = false
				$AnimatedSprite2D.play("TreeHit")
				$AnimatedSprite2D.play("TreeHit")
				$AnimatedSprite2D.flip_h=true
			if Input.is_action_just_released("interactuar"):
				$AnimatedSprite2D.play("TreeStay")
				$AnimatedSprite2D.flip_h=false
				$TimerTalarArbol.paused = true
			
		if DentroAbajo==true:
			if Input.is_action_pressed("interactuar"):
				if $TimerTalarArbol.get_time_left() == 0:
					$TimerTalarArbol.start()
				else:
					$TimerTalarArbol.paused = false
				$AnimatedSprite2D.play("TreeHit")
			if Input.is_action_just_released("interactuar"):
				$AnimatedSprite2D.play("TreeStay")
				$TimerTalarArbol.paused = true
	# Estado : Si está muerto
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
	$TimerTalarArbol.paused = true
	$AnimatedSprite2D.play("TreeStay")
	# Salida Colisión : Left
	DentroIzq = false
	# Salida Colisión : Right
	DentroDer = false
	# Salida Colisión : Up
	DentroArriba = false
	# Salida Colisión : Down
	DentroAbajo = false

func _on_tree_respawn_timeout():
	TiempoRespawn=false
	VidaTree=true
	$AnimatedSprite2D.play("TreeStay")


func _on_timer_talar_arbol_timeout():
	VidaTree=false
	$TimerTalarArbol.stop()


func _on_animated_sprite_2d_frame_changed():
	if $AnimatedSprite2D.animation=="TreeHit":
		if $AnimatedSprite2D.frame==2:
			talarSound.emit()
