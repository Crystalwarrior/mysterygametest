extends TileMap

# The tilemap to target for fov data
@export var target_tilemap: TileMap
# Player node to target
@export var target_node: Node2D

@export var vision_range: int = 9

var map_size: Vector2i

var player_pos: Vector2i

var tilesize_difference: int = 1

# The shadowcasting algorithm used for visibility checks.
var _mrpas: MRPAS

func _ready():
	tilesize_difference = target_tilemap.tile_set.tile_size.x / tile_set.tile_size.x

	_populate_mrpas()
	_compute_field_of_view()

func _process(delta):
	var old_player_pos = player_pos
	player_pos = local_to_map(to_local(target_node.global_position))
	# Our position changed, update the field of view!
	if player_pos != old_player_pos:
		_compute_field_of_view()

# Populate the shadowcasting algorithm with transparent / occluded cells
# using the position of walls on the map.
func _populate_mrpas() -> void:
	map_size = (target_tilemap.get_used_rect().position + target_tilemap.get_used_rect().size) * tilesize_difference
	_mrpas = MRPAS.new(map_size)

	for y in range(map_size.y):
		for x in range(map_size.x):
			var map_position = Vector2i(x, y) / tilesize_difference
			var data = target_tilemap.get_cell_tile_data(0, map_position)
			var block_fov = false
			if data:
				block_fov = data.get_custom_data("block_fov")

			# Specifically check for walls and assume all other cells are
			# transparent.
			_mrpas.set_transparent(Vector2i(x, y), not block_fov)


# Recompute which map cells are visible.
func _compute_field_of_view() -> void:
	# Mark all map cells as not in view.
	_mrpas.clear_field_of_view()

	# Use shadowcasting to find the cells which are visible from the
	# new payer position.
	_mrpas.compute_field_of_view(player_pos, vision_range)

	for y in range(map_size.y):
		for x in range(map_size.x):
			var map_position = Vector2i(x, y)

			# Mark the cell as visible if the shadowcasting has found it
			# to be in view.
			if _mrpas.is_in_view(map_position):
				erase_cell(0, map_position)
			else:
				set_cell(0, map_position, 0, Vector2i(0, 0))
