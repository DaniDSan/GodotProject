extends Area2D

var enemies = []
var current_target
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_target != null:
		$Marker2D.look_at(current_target.get_parent().global_position)
func _on_body_entered(body):
	enemies.append(body)
	current_target = enemies[0]
func _on_body_exited(body):
	enemies.remove_at(0)
	if enemies.is_empty():
		current_target = null
