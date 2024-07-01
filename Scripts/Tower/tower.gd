extends Area2D

var enemies = []
var current_target
@export var bullet: PackedScene
var canAttack = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if current_target != null:
		$Marker2D.look_at(current_target.get_parent().global_position)
		if canAttack:
			$AttackTimer.start()
			canAttack = false
			var tem_bullet = bullet.instantiate()
			$BulletContainer.add_child(tem_bullet)
			tem_bullet.position = $Marker2D/Sprite2D2/ShootingPoint.global_position
			tem_bullet.look_at(current_target.get_parent().global_position)
		
func _on_body_entered(body):
	enemies.append(body)
	current_target = enemies[0]
	
func _on_body_exited(_body):
	enemies.remove_at(0)
	if enemies.is_empty():
		current_target = null

func _on_attack_timer_timeout():
	canAttack = true
