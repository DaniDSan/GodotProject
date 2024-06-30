extends Area2D

var is_empty = true
var holded_object

var tile_map: TileMap
var filled_tiles = []

func _ready():
	tile_map = get_parent().get_parent().get_node("TileMap")
	
func _process(delta):
	_grab_object()
	_place_object()

func _on_body_entered(body):
	if !is_empty:
		return
	is_empty = false
	holded_object = body

func _grab_object():
	if !is_empty:
		holded_object.global_position = global_position
		
func _place_object():
	if !is_empty:
		var map_pos = tile_map.map_to_local(tile_map.local_to_map(global_position))
		if Input.is_action_just_pressed("interactuar") && !filled_tiles.has(map_pos):
			holded_object.global_position = map_pos
			filled_tiles.append(map_pos)
			is_empty = true
