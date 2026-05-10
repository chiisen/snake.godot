extends Node

var grid_size: Vector2i = Vector2i(20, 20)
var cell_size: int = 32
var snake_position: Array = []
var food_position: Vector2i
var direction: Vector2i = Vector2i.RIGHT
var score: int = 0
var high_score: int = 0
var base_speed: float = 0.2
var current_speed: float = 0.2
var is_game_over: bool = false

@onready var snake = $"../Snake"
@onready var food = $"../Food"
@onready var ui = $"../UI"
@onready var move_timer = $MoveTimer

func _ready():
	load_high_score()
	reset_game()
	move_timer.timeout.connect(move)
	move_timer.start()

func reset_game():
	snake_position = [Vector2i(10, 10)]
	direction = Vector2i.RIGHT
	score = 0
	current_speed = base_speed
	is_game_over = false
	
	spawn_food()
	update_game()

func update_game():
	snake.update_visuals(snake_position, cell_size)
	food.set_grid_position(food_position)
	ui.update_score(score)
	ui.update_high_score(high_score)
	move_timer.wait_time = current_speed

func spawn_food():
	var valid_positions = []
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			var pos = Vector2i(x, y)
			if not pos in snake_position:
				valid_positions.append(pos)
	
	if valid_positions.size() > 0:
		food_position = valid_positions[randi() % valid_positions.size()]

func load_high_score():
	var save_path = "user://high_score.save"
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		var data = JSON.parse_string(file.get_line())
		if data != null and data.has("high_score"):
			high_score = data["high_score"]

func save_high_score():
	if score > high_score:
		high_score = score
		var save_path = "user://high_score.save"
		var file = FileAccess.open(save_path, FileAccess.WRITE)
		file.store_line(JSON.stringify({"high_score": high_score}))

func move():
	if is_game_over:
		return
	
	var new_head = snake_position[0] + direction
	
	if check_collision(new_head):
		game_over()
		return
	
	if new_head == food_position:
		snake_position.insert(0, new_head)
		score += 1
		spawn_food()
		update_speed()
	else:
		snake_position.insert(0, new_head)
		snake_position.pop_back()
	
	update_game()

func update_speed():
	current_speed = base_speed - (score * 0.005)
	current_speed = max(current_speed, 0.05)
	move_timer.wait_time = current_speed

func check_collision(new_head: Vector2i) -> bool:
	if new_head.x < 0 or new_head.x >= grid_size.x:
		return true
	if new_head.y < 0 or new_head.y >= grid_size.y:
		return true
	
	if new_head in snake_position:
		return true
	
	return false

func game_over():
	is_game_over = true
	move_timer.stop()
	save_high_score()
	ui.show_game_over(score)

func _input(event):
	if is_game_over:
		return
	
	if event is InputEventKey and event.pressed:
		var new_direction = direction
		
		if event.keycode == KEY_UP or event.keycode == KEY_W:
			new_direction = Vector2i.UP
		elif event.keycode == KEY_DOWN or event.keycode == KEY_S:
			new_direction = Vector2i.DOWN
		elif event.keycode == KEY_LEFT or event.keycode == KEY_A:
			new_direction = Vector2i.LEFT
		elif event.keycode == KEY_RIGHT or event.keycode == KEY_D:
			new_direction = Vector2i.RIGHT
		
		if new_direction != direction and new_direction != -direction:
			direction = new_direction