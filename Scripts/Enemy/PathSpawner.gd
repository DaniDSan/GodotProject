extends Node2D

@onready var path = preload("res://Scenes/Enemy/enemyPathing.tscn")
var total_enemies = 10

func _on_spawn_rate_timer_timeout():
	if total_enemies > 0:
		spawnEnemies()
	else:
		$SpawnRateTimer.stop()
	
func _on_start_timer_timeout():
	$SpawnRateTimer.start()
	spawnEnemies()

func spawnEnemies():
	var temp_path = path.instantiate()
	add_child(temp_path)
	total_enemies -= 1
