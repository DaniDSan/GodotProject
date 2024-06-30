extends Node2D

@export var truck: PackedScene
@export var tile_map: TileMap
var filled_tiles = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var map_pos = tile_map.map_to_local(tile_map.local_to_map(get_global_mouse_position()))
	if Input.is_action_just_pressed("click") && !filled_tiles.has(map_pos):
		var temp_truck = truck.instantiate()
		add_child(temp_truck)
		temp_truck.position = map_pos
		filled_tiles.append(map_pos)
