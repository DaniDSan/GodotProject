extends Area2D

var is_empty = true
var holded_object

func _process(delta):
	if !is_empty:
		holded_object.global_position = global_transform.origin

func _on_body_entered(body):
	is_empty = false
	holded_object = body
