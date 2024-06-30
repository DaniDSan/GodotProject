extends TileMap

@export var truck: PackedScene
var tile_size = [64, 64]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("click"):
		var temp_truck = truck.instantiate()
		add_child(temp_truck)
		temp_truck.position = local_to_map(get_global_mouse_position())
