extends Area2D

var is_empty = true
var holded_object

var tile_map: TileMap
var filled_tiles = []

@export var tower: PackedScene

func _ready():
	tile_map = get_parent().get_parent().get_node("TileMap")
	
func _process(delta):
	grab_object()
	place_object()
	
func _on_area_entered(area):
	if !is_empty:
		return
	is_empty = false
	holded_object = area

func grab_object():
	if !is_empty:
		holded_object.global_position = global_position
		
func place_object():
	if !is_empty:
		var map_pos = tile_map.map_to_local(tile_map.local_to_map(global_position))
		if Input.is_action_just_pressed("interactuar") && !filled_tiles.has(map_pos):
			holded_object.queue_free()
			var temp_tower = tower.instantiate()
			find_parent("Main").add_child(temp_tower)
			temp_tower.global_position = map_pos
			filled_tiles.append(map_pos)
			is_empty = true
