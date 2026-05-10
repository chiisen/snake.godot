extends Node2D

var body_sprites: Array = []
var cell_size: int = 32

@onready var head_sprite: Sprite2D = $Head
@onready var left_eye: Sprite2D = $Head/Eyes/LeftEye
@onready var right_eye: Sprite2D = $Head/Eyes/RightEye
@onready var body_container: Node2D = $Body

func _ready():
	head_sprite.texture = create_circle_texture(cell_size * 0.8, Color(0.2, 0.6, 0.2, 1.0))
	
	left_eye.texture = create_circle_texture(cell_size * 0.15, Color(1, 1, 1, 1.0))
	right_eye.texture = create_circle_texture(cell_size * 0.15, Color(1, 1, 1, 1.0))
	left_eye.offset = Vector2(-5, -5) + Vector2(cell_size * 0.15 / 2.0, cell_size * 0.15 / 2.0)
	right_eye.offset = Vector2(5, -5) + Vector2(cell_size * 0.15 / 2.0, cell_size * 0.15 / 2.0)
	
	body_sprites = []

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

func update_visuals(positions: Array, size: int):
	if positions.size() > 0 and head_sprite:
		head_sprite.position = Vector2(
			positions[0].x * size + size / 2.0,
			positions[0].y * size + size / 2.0
		)
	
	for i in range(1, positions.size()):
		if i - 1 >= body_sprites.size():
			var body_sprite = Sprite2D.new()
			body_sprite.texture = create_circle_texture(size * 0.7, Color(0.3, 0.7, 0.3, 1.0))
			body_sprite.offset = Vector2(size / 2.0, size / 2.0)
			body_container.add_child(body_sprite)
			body_sprites.append(body_sprite)
		
		body_sprites[i - 1].position = Vector2(
			positions[i].x * size,
			positions[i].y * size
		)