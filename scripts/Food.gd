extends Sprite2D

var cell_size: int = 32

func set_grid_position(grid_pos: Vector2i):
	position = Vector2(grid_pos.x * cell_size, grid_pos.y * cell_size)