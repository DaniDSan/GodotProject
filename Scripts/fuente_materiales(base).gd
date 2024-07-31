extends Area2D


# Collisiones : Dentro del árbol
var DentroIzq = false
var DentroDer = false
var DentroArriba = false
var DentroAbajo = false

# Sonido : señales para sonido en el main
signal talarSound

# Respawn : Hace que aparezca SOLO 1 tronco
var MaterialSpawnAbierto = false

# Respawn : Activa el timer de respawn del Árbol
var TiempoRespawn = false

# Respawn : PackedScene del Tronco y numero aleatorios indicando la zona donde spawnean
@export var Materiales: PackedScene

# Estado : Si está vivo o muerto el Árbol
var Vida = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("TreeStay")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	# Estado : Si está vivo
	if Vida==true:
		MaterialSpawnAbierto=false
		if DentroIzq==true:
			if Input.is_action_pressed("interactuar"):
				if $TiempoInteracción.get_time_left() == 0:
					$TiempoInteracción.start()
				else:
					$TiempoInteracción.paused = false
				$AnimatedSprite2D.play("TreeHit")
				$AnimatedSprite2D.flip_h=true
			if Input.is_action_just_released("interactuar"):
				$AnimatedSprite2D.play("TreeStay")
				$AnimatedSprite2D.flip_h=false
				$TiempoInteracción.paused = true
				
		if DentroDer == true:
			if Input.is_action_pressed("interactuar"):
				if $TiempoInteracción.get_time_left() == 0:
					$TiempoInteracción.start()
				else:
					$TiempoInteracción.paused = false
				$AnimatedSprite2D.play("TreeHit")
			if Input.is_action_just_released("interactuar"):
				$AnimatedSprite2D.play("TreeStay")
				$TiempoInteracción.paused = true
				
		if DentroArriba==true:
			if Input.is_action_pressed("interactuar"):
				if $TiempoInteracción.get_time_left() == 0:
					$TiempoInteracción.start()
				else:
					$TiempoInteracción.paused = false
				$AnimatedSprite2D.play("TreeHit")
				$AnimatedSprite2D.play("TreeHit")
				$AnimatedSprite2D.flip_h=true
			if Input.is_action_just_released("interactuar"):
				$AnimatedSprite2D.play("TreeStay")
				$AnimatedSprite2D.flip_h=false
				$TiempoInteracción.paused = true
			
		if DentroAbajo==true:
			if Input.is_action_pressed("interactuar"):
				if $TiempoInteracción.get_time_left() == 0:
					$TiempoInteracción.start()
				else:
					$TiempoInteracción.paused = false
				$AnimatedSprite2D.play("TreeHit")
			if Input.is_action_just_released("interactuar"):
				$AnimatedSprite2D.play("TreeStay")
				$TiempoInteracción.paused = true
	# Estado : Si está muerto
	else:
		$AnimatedSprite2D.play("TreeChopped")
		$AnimatedSprite2D.flip_h=false
		if TiempoRespawn==false:
			TiempoRespawn=true
			$TiempoRespawn.start()
		if MaterialSpawnAbierto==false:
			SpawnTronco()
			MaterialSpawnAbierto=true

func SpawnTronco():
	var spawnArea = $SpawnMaterial/AreaSpawnMaterial.shape.extents
	var origin = $SpawnMaterial/AreaSpawnMaterial.position
	
	var rigidBodyArea = $RigidBody/AreaRigidBody.shape.extents

	var MaterialesTemp = Materiales.instantiate()
	
	add_child(MaterialesTemp)

	var x = randf_range(-spawnArea.x , spawnArea.x)
	var y = randf_range(-spawnArea.y , spawnArea.y)

	MaterialesTemp.position.x = x + origin.x
	MaterialesTemp.position.y = y + origin.y
	
	var oniichan=true
	
	while oniichan==true:
		if MaterialesTemp.position.x >= - rigidBodyArea.x and MaterialesTemp.position.x <= rigidBodyArea.x and MaterialesTemp.position.y >= - rigidBodyArea.y and MaterialesTemp.position.y <= rigidBodyArea.y:
			x = randf_range(-spawnArea.x , spawnArea.x)
			y = randf_range(-spawnArea.y , spawnArea.y)
			
			MaterialesTemp.position.x = x + origin.x
			MaterialesTemp.position.y = y + origin.y
			oniichan=true
		else:
			oniichan=false
	
func _on_body_entered(body):
	
	var colisionTalarPuntoMedio = $CollisionInteractuar.shape.extents
	var colisionTalarPosicion = $CollisionInteractuar.position
	
	var positionGlobalColision = global_position + colisionTalarPosicion

	# Entra Colisión : Left
	if body.position.x < (positionGlobalColision.x - colisionTalarPuntoMedio.x):
		DentroIzq = true
	# Entra Colisión : Right
	if body.position.x > (positionGlobalColision.x + colisionTalarPuntoMedio.x):
		DentroDer = true
	# Entra Colisión : Up
	if body.position.y < (positionGlobalColision.y - colisionTalarPuntoMedio.y):
		DentroArriba = true
	# Entra Colisión : Down
	if body.position.y > (positionGlobalColision.y + colisionTalarPuntoMedio.y):
		DentroAbajo = true
	
func _on_body_exited(_body):
	$TiempoInteracción.paused = true
	$AnimatedSprite2D.play("TreeStay")
	# Salida Colisión : Left
	DentroIzq = false
	# Salida Colisión : Right
	DentroDer = false
	# Salida Colisión : Up
	DentroArriba = false
	# Salida Colisión : Down
	DentroAbajo = false

func _on_tiempo_respawn_timeout():
	TiempoRespawn=false
	Vida=true
	$AnimatedSprite2D.play("TreeStay")

func _on_tiempo_interacción_timeout():
	Vida=false
	$TiempoInteracción.stop()

func _on_animated_sprite_2d_frame_changed():
	if $AnimatedSprite2D.animation=="TreeHit":
		if $AnimatedSprite2D.frame==2:
			talarSound.emit()

