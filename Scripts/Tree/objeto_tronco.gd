extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	$AnimacionTronco.play("Spawn")
	$TroncoSpawn.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

