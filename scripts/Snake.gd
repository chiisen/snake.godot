extends Node2D

var body_sprites: Array = []
var head_sprite: Sprite2D
var cell_size: int = 32

func _ready():
	head_sprite = $Head
	head_sprite.texture = create_circle_texture(cell_size * 0.8, Color(0.2, 0.6, 0.2))
	
	var left_eye = $Head/Eyes/LeftEye
	var right_eye = $Head/Eyes/RightEye
	left_eye.texture = create_circle_texture(cell_size * 0.15, Color(1, 1, 1))
	right_eye.texture = create_circle_texture(cell_size * 0.15, Color(1, 1, 1))
	left_eye.offset = Vector2(-5, -5) + Vector2(cell_size * 0.15 / 2, cell_size * 0.15 / 2)
	right_eye.offset = Vector2(5, -5) + Vector2(cell_size * 0.15 / 2, cell_size * 0.15 / 2)
	
	body_sprites = []

func create_circle_texture(size: float, color: Color) -> ImageTexture:
	var img = Image.create(int(size), int(size), false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))
	
	var center = Vector2(size / 2, size / 2)
	var radius = size / 2
	for x in range(int(size)):
		for y in range(int(size)):
			var dist = Vector2(x, y).distance_to(center)
			if dist <= radius:
				img.set_pixel(x, y, color)
	
	var texture = ImageTexture.create_from_image(img)
	return texture

func update_visuals(positions: Array, cell_size: int):
	if positions.size() > 0:
		head_sprite.position = Vector2(
			positions[0].x * cell_size + cell_size / 2,
			positions[0].y * cell_size + cell_size / 2
		)
	
	for i in range(1, positions.size()):
		if i - 1 >= body_sprites.size():
			var body_sprite = Sprite2D.new()
			body_sprite.texture = create_circle_texture(cell_size * 0.7, Color(0.3, 0.7, 0.3))
			body_sprite.offset = Vector2(cell_size / 2, cell_size / 2)
			$Body.add_child(body_sprite)
			body_sprites.append(body_sprite)
		
		body_sprites[i - 1].position = Vector2(
			positions[i].x * cell_size,
			positions[i].y * cell_size
		)