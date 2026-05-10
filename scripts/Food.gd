extends Sprite2D

var cell_size: int = 32
var base_position: Vector2

func _ready():
	texture = create_circle_texture(cell_size * 0.6, Color(1, 0.3, 0.3, 1.0))
	offset = Vector2(cell_size / 2.0, cell_size / 2.0)

func create_circle_texture(size: float, color: Color) -> ImageTexture:
	var img = Image.create(int(size), int(size), false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))
	
	var center = Vector2(size / 2.0, size / 2.0)
	var radius = size / 2.0
	for x in range(int(size)):
		for y in range(int(size)):
			var dist = Vector2(x, y).distance_to(center)
			if dist <= radius:
				img.set_pixel(x, y, color)
	
	var tex = ImageTexture.create_from_image(img)
	return tex

func set_grid_position(grid_pos: Vector2i):
	base_position = Vector2(grid_pos.x * cell_size, grid_pos.y * cell_size)
	position = base_position
	start_float_animation()

func start_float_animation():
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(self, "position:y", base_position.y - 3, 0.5)
	tween.tween_property(self, "position:y", base_position.y + 3, 0.5)