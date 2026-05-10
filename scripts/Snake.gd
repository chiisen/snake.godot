extends Node2D

var body_sprites: Array = []
var head_sprite: Sprite2D

func _ready():
	head_sprite = $Head
	body_sprites = []

func update_visuals(positions: Array, cell_size: int):
	if positions.size() > 0:
		head_sprite.position = Vector2(positions[0].x * cell_size, positions[0].y * cell_size)
	
	for i in range(1, positions.size()):
		if i - 1 >= body_sprites.size():
			var body_sprite = Sprite2D.new()
			body_sprite.modulate = Color(0.3, 0.7, 0.3)
			$Body.add_child(body_sprite)
			body_sprites.append(body_sprite)
		
		body_sprites[i - 1].position = Vector2(positions[i].x * cell_size, positions[i].y * cell_size)