extends Area2D

var is_empty = true
var holded_object
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_empty:
		holded_object.global_position = global_transform.origin

func _on_body_entered(body):
	is_empty = false
	holded_object = body
