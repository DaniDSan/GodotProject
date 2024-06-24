extends PathFollow2D

@export var speed = 200
var next_pos
var sprite_pos
@export var offset = [5, 5]
var i = 1
var max_i
var rotate_sprite = false
var sprite_scale
var rotation_speed = 15
# Called when the node enters the scene tree for the first time.
func _ready():
	_get_values()
		
func _get_values():
	sprite_pos = position
	next_pos = get_parent().curve.get_point_position(i)
	max_i = get_parent().curve.point_count - 1
	rotate_sprite = sprite_pos.x > next_pos.x
	if rotate_sprite:
		sprite_scale = Vector2(1, 1)
	else:
		sprite_scale = Vector2(1, 1)
		get_child(0).get_child(0).scale = sprite_scale

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_path_movement(delta)
	_sprite_orientation(delta)
	
func _path_movement(delta):
	progress += speed * delta
	
func _sprite_orientation(delta):
	sprite_pos = position
	if (sprite_pos.x >= next_pos.x - 5 && sprite_pos.x <= next_pos.x + 5) && (sprite_pos.y >= next_pos.y - 5 && sprite_pos.y <= next_pos.y + 5):
		i += 1
		if i > max_i:
			i = max_i
			queue_free()
		next_pos = get_parent().curve.get_point_position(i)
		rotate_sprite = sprite_pos.x > next_pos.x
	if rotate_sprite:
		sprite_scale = Vector2(-1, 1)
	else:
		sprite_scale = Vector2(1, 1)
		get_child(0).get_child(0).scale
	get_child(0).get_child(0).scale = lerp(get_child(0).get_child(0).scale, sprite_scale, rotation_speed * delta)
