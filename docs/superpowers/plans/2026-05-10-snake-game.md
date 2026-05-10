# Snake Game Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a classic snake game with cartoon style, progressive speed, and keyboard controls (Arrow keys + WASD).

**Architecture:** Node2D + Grid system with GameManager controlling game logic, Snake handling visuals, Food managing spawn behavior, and UI displaying scores. Timer-based movement ensures grid alignment.

**Tech Stack:** Godot 4.2.2, GDScript, Node2D, Sprite2D, Timer, CanvasLayer

---

## File Structure

```
scenes/
  Main.tscn          - Root scene with all components
  Snake.tscn         - Snake prefab (head + body segments)
  Food.tscn          - Food prefab

scripts/
  GameManager.gd     - Game logic (move, collision, score, speed)
  Snake.gd           - Snake visuals (update positions, expressions)
  Food.gd            - Food behavior (spawn, float animation)
  UI.gd              - UI management (score display, game over screen)

assets/
  sprites/
    (暫不建立 - 使用代碼繪製彩色圓形)
  animations/
    (暫不建立 - 後續任務中加入)
```

---

### Task 1: 建立專案目錄結構

**Files:**
- Create directory: `scenes/`
- Create directory: `scripts/`
- Create directory: `assets/sprites/`
- Create directory: `assets/animations/`

- [ ] **Step 1: 建立目錄結構**

Run via Godot MCP:
```
無需執行 - 目錄會在建立檔案時自動創建
```

- [ ] **Step 2: 验证目錄結構**

Run: `ls -R` in project root
Expected: 空目錄結構已建立

---

### Task 2: 建立 Snake 基本場景

**Files:**
- Create: `scenes/Snake.tscn`
- Create: `scripts/Snake.gd`

- [ ] **Step 1: 建立 Snake.tscn 基本場景**

使用 Godot MCP 建立場景：
```gdscript
# Snake.tscn 結構
[gd_scene load_steps=2 format=3]

[ext_resource path="res://scripts/Snake.gd" type="Script" id=1]

[node name="Snake" type="Node2D"]
script = ExtResource( 1 )

[node name="Head" type="Sprite2D" parent="."]
modulate = Color(0.2, 0.6, 0.2)  # 綠色蛇頭

[node name="Body" type="Node2D" parent="."]
```

- [ ] **Step 2: 建立 Snake.gd 基本腳本**

```gdscript
# scripts/Snake.gd
extends Node2D

var body_sprites: Array = []
var head_sprite: Sprite2D

func _ready():
	head_sprite = $Head
	body_sprites = []
	
func update_visuals(positions: Array, cell_size: int):
	# 更新蛇頭位置
	if positions.size() > 0:
		head_sprite.position = Vector2(positions[0].x * cell_size, positions[0].y * cell_size)
	
	# 更新蛇身
	for i in range(1, positions.size()):
		if i - 1 >= body_sprites.size():
			# 需要新增蛇身 Sprite
			var body_sprite = Sprite2D.new()
			body_sprite.modulate = Color(0.3, 0.7, 0.3)  # 綠色蛇身
			$Body.add_child(body_sprite)
			body_sprites.append(body_sprite)
		
		body_sprites[i - 1].position = Vector2(positions[i].x * cell_size, positions[i].y * cell_size)
```

- [ ] **Step 3: 验证 Snake 基本場景**

在 Godot Editor 中：
- 開啟 `scenes/Snake.tscn`
- 確認 Snake node 有 Head 和 Body 子節點
- 確認 Head 是綠色 Sprite2D

- [ ] **Step 4: Commit**

```bash
git add scenes/Snake.tscn scripts/Snake.gd
git commit -m "feat(snake): 建立基本 Snake 場景和腳本"
```

---

### Task 3: 建立 Food 基本場景

**Files:**
- Create: `scenes/Food.tscn`
- Create: `scripts/Food.gd`

- [ ] **Step 1: 建立 Food.tscn 基本場景**

使用 Godot MCP：
```gdscript
# Food.tscn 結構
[gd_scene load_steps=2 format=3]

[ext_resource path="res://scripts/Food.gd" type="Script" id=1]

[node name="Food" type="Sprite2D"]
script = ExtResource( 1 )
modulate = Color(1, 0.3, 0.3)  # 紅色食物
```

- [ ] **Step 2: 建立 Food.gd 基本腳本**

```gdscript
# scripts/Food.gd
extends Sprite2D

var cell_size: int = 32

func set_grid_position(grid_pos: Vector2i):
	position = Vector2(grid_pos.x * cell_size, grid_pos.y * cell_size)
```

- [ ] **Step 3: 验证 Food 基本場景**

在 Godot Editor 中：
- 開啟 `scenes/Food.tscn`
- 確認 Food 是紅色 Sprite2D

- [ ] **Step 4: Commit**

```bash
git add scenes/Food.tscn scripts/Food.gd
git commit -m "feat(food): 建立基本 Food 場景和腳本"
```

---

### Task 4: 建立 Main 場景結構

**Files:**
- Create: `scenes/Main.tscn`
- Create: `scripts/GameManager.gd`
- Create: `scripts/UI.gd`

- [ ] **Step 1: 建立 Main.tscn 基本場景**

使用 Godot MCP：
```gdscript
# Main.tscn 結構
[gd_scene load_steps=5 format=3]

[ext_resource path="res://scripts/GameManager.gd" type="Script" id=1]
[ext_resource path="res://scenes/Snake.tscn" type="PackedScene" id=2]
[ext_resource path="res://scenes/Food.tscn" type="PackedScene" id=3]
[ext_resource path="res://scripts/UI.gd" type="Script" id=4]

[node name="Main" type="Node2D"]

[node name="GameManager" type="Node" parent="."]
script = ExtResource( 1 )

[node name="Snake" parent="." instance=ExtResource( 2 )]

[node name="Food" parent="." instance=ExtResource( 3 )]

[node name="UI" type="CanvasLayer" parent="."]
script = ExtResource( 4 )

[node name="ScoreLabel" type="Label" parent="UI"]
offset_left = 10
offset_top = 10
text = "Score: 0"

[node name="HighScoreLabel" type="Label" parent="UI"]
offset_left = 10
offset_top = 30
text = "High Score: 0"

[node name="GameOverPanel" type="Control" parent="UI"]
visible = false
layout_mode = 3
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
grow_horizontal = 2
grow_vertical = 2

[node name="GameOverLabel" type="Label" parent="UI/GameOverPanel"]
layout_mode = 1
anchors_preset = 8
anchor_left = 0.5
anchor_top = 0.5
anchor_right = 0.5
anchor_bottom = 0.5
offset_left = -50
offset_top = -30
offset_right = 50
offset_bottom = 30
text = "Game Over"
horizontal_alignment = 1

[node name="FinalScoreLabel" type="Label" parent="UI/GameOverPanel"]
layout_mode = 1
anchors_preset = 8
anchor_left = 0.5
anchor_top = 0.5
anchor_right = 0.5
anchor_bottom = 0.5
offset_left = -50
offset_top = 10
offset_right = 50
offset_bottom = 50
text = "Final Score: 0"
horizontal_alignment = 1

[node name="RestartButton" type="Button" parent="UI/GameOverPanel"]
layout_mode = 1
anchors_preset = 8
anchor_left = 0.5
anchor_top = 0.5
anchor_right = 0.5
anchor_bottom = 0.5
offset_left = -40
offset_top = 60
offset_right = 40
offset_bottom = 90
text = "Restart"

[node name="MoveTimer" type="Timer" parent="GameManager"]
wait_time = 0.2
```

- [ ] **Step 2: 建立 GameManager.gd 基本架構**

```gdscript
# scripts/GameManager.gd
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

func reset_game():
	snake_position = [Vector2i(10, 10)]  # 蛇初始在中央
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
	# 隨機生成食物位置（確保不在蛇身上）
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
```

- [ ] **Step 3: 建立 UI.gd 基本腳本**

```gdscript
# scripts/UI.gd
extends CanvasLayer

@onready var score_label = $ScoreLabel
@onready var high_score_label = $HighScoreLabel
@onready var game_over_panel = $GameOverPanel
@onready var final_score_label = $GameOverPanel/FinalScoreLabel
@onready var restart_button = $GameOverPanel/RestartButton

func _ready():
	restart_button.pressed.connect(_on_restart_pressed)

func update_score(score: int):
	score_label.text = "Score: %d" % score

func update_high_score(high_score: int):
	high_score_label.text = "High Score: %d" % high_score

func show_game_over(final_score: int):
	game_over_panel.visible = true
	final_score_label.text = "Final Score: %d" % final_score

func hide_game_over():
	game_over_panel.visible = false

func _on_restart_pressed():
	hide_game_over()
	var game_manager = $"../GameManager"
	game_manager.reset_game()
	game_manager.move_timer.start()
```

- [ ] **Step 4: 验证 Main 場景**

在 Godot Editor 中：
- 開啟 `scenes/Main.tscn`
- 確認結構：Main → GameManager, Snake, Food, UI
- 確認 UI 有 ScoreLabel, HighScoreLabel, GameOverPanel
- 確認 GameOverPanel 有 GameOverLabel, FinalScoreLabel, RestartButton
- 確認 GameManager 有 MoveTimer

- [ ] **Step 5: Commit**

```bash
git add scenes/Main.tscn scripts/GameManager.gd scripts/UI.gd
git commit -m "feat(main): 建立主場景結構和基本腳本"
```

---

### Task 5: 實作蛇移動邏輯

**Files:**
- Modify: `scripts/GameManager.gd` (新增 move() 和 Timer 連接)

- [ ] **Step 1: 在 GameManager 中新增 move() 函數**

```gdscript
# 在 scripts/GameManager.gd 中新增

func move():
	if is_game_over:
		return
	
	# 計算新蛇頭位置
	var new_head = snake_position[0] + direction
	
	# 碰撞檢測
	if check_collision(new_head):
		game_over()
		return
	
	# 正常移動（刪除尾巴、新增頭）
	snake_position.insert(0, new_head)
	snake_position.pop_back()
	
	update_game()

func check_collision(new_head: Vector2i) -> bool:
	# 撞牆檢測
	if new_head.x < 0 or new_head.x >= grid_size.x:
		return true
	if new_head.y < 0 or new_head.y >= grid_size.y:
		return true
	
	# 撞自己檢測
	if new_head in snake_position:
		return true
	
	return false

func game_over():
	is_game_over = true
	move_timer.stop()
	save_high_score()
	ui.show_game_over(score)
```

- [ ] **Step 2: 連接 Timer timeout 信號**

```gdscript
# 在 scripts/GameManager.gd 的 _ready() 中新增

func _ready():
	load_high_score()
	reset_game()
	move_timer.timeout.connect(move)
	move_timer.start()
```

- [ ] **Step 3: 手動測試移動功能**

在 Godot Editor 中：
- 運行 Main 場景（F5）
- 觀察蛇是否每 0.2 秒向右移動一格
- 確認蛇消失在右邊界時觸發 Game Over

- [ ] **Step 4: Commit**

```bash
git add scripts/GameManager.gd
git commit -m "feat(game): 實作蛇移動邏輯和碰撞檢測"
```

---

### Task 6: 實作輸入處理

**Files:**
- Modify: `scripts/GameManager.gd` (新增 _input())

- [ ] **Step 1: 在 GameManager 中新增輸入處理**

```gdscript
# 在 scripts/GameManager.gd 中新增

func _input(event):
	if is_game_over:
		return
	
	if event is InputEventKey and event.pressed:
		var new_direction = direction
		
		# 方向鍵或 WASD
		if event.keycode == KEY_UP or event.keycode == KEY_W:
			new_direction = Vector2i.UP
		elif event.keycode == KEY_DOWN or event.keycode == KEY_S:
			new_direction = Vector2i.DOWN
		elif event.keycode == KEY_LEFT or event.keycode == KEY_A:
			new_direction = Vector2i.LEFT
		elif event.keycode == KEY_RIGHT or event.keycode == KEY_D:
			new_direction = Vector2i.RIGHT
		
		# 防止反向移動
		if new_direction != direction and new_direction != -direction:
			direction = new_direction
```

- [ ] **Step 2: 手動測試輸入功能**

在 Godot Editor 中：
- 運行 Main 場景（F5）
- 測試方向鍵 ↑↓←→ 控制蛇移動
- 測試 WASD 控制蛇移動
- 測試不能反向移動（例如：向右時不能立即向左）

- [ ] **Step 3: Commit**

```bash
git add scripts/GameManager.gd
git commit -m "feat(input): 實作方向鍵和 WASD 輸入處理"
```

---

### Task 7: 實作吃食物邏輯

**Files:**
- Modify: `scripts/GameManager.gd` (修改 move() 加入吃食物判斷)

- [ ] **Step 1: 修改 move() 函數加入吃食物判斷**

```gdscript
# 在 scripts/GameManager.gd 的 move() 函數中修改

func move():
	if is_game_over:
		return
	
	var new_head = snake_position[0] + direction
	
	if check_collision(new_head):
		game_over()
		return
	
	# 檢查是否吃到食物
	if new_head == food_position:
		# 吃到食物：新增頭、不刪除尾巴、分數+1
		snake_position.insert(0, new_head)
		score += 1
		spawn_food()
		update_speed()
	else:
		# 正常移動
		snake_position.insert(0, new_head)
		snake_position.pop_back()
	
	update_game()
```

- [ ] **Step 2: 新增 update_speed() 函數**

```gdscript
# 在 scripts/GameManager.gd 中新增

func update_speed():
	current_speed = base_speed - (score * 0.005)
	current_speed = max(current_speed, 0.05)  # 最小速度限制
	move_timer.wait_time = current_speed
```

- [ ] **Step 3: 手動測試吃食物功能**

在 Godot Editor 中：
- 遊戲 Main 場景（F5）
- 控制蛇移動到食物位置
- 確認蛇身增長一格
- 積分增加 1
- 新食物生成在隨機位置
- 速度逐漸加快（觀察 Timer wait_time）

- [ ] **Step 4: Commit**

```bash
git add scripts/GameManager.gd
git commit -m "feat(food): 實作吃食物邏輯和速度漸進"
```

---

### Task 8: 調整撞自己碰撞檢測

**Files:**
- Modify: `scripts/GameManager.gd` (修正撞自己檢測邏輯)

- [ ] **Step 1: 修正撞自己檢測**

當前的撞自己檢測會在新頭插入後才檢查，需要修正為檢查新頭是否與當前蛇身重疊（不包括尾巴，因為尾巴會移動）。

```gdscript
# 在 scripts/GameManager.gd 中修改 check_collision()

func check_collision(new_head: Vector2i) -> bool:
	# 撞牆檢測
	if new_head.x < 0 or new_head.x >= grid_size.x:
		return true
	if new_head.y < 0 or new_head.y >= grid_size.y:
		return true
	
	# 撞自己檢測（不包括尾巴，因為尾巴會移動）
	for i in range(snake_position.size() - 1):
		if new_head == snake_position[i]:
			return true
	
	return false
```

- [ ] **Step 2: 手動測試撞自己檢測**

在 Godot Editor 中：
- 遊戲 Main 場景（F5）
- 控制蛇移動形成迴圈
- 煽蛇頭撞到蛇身時觸發 Game Over

- [ ] **Step 3: Commit**

```bash
git add scripts/GameManager.gd
git commit -m "fix(collision): 修正撞自己檢測邏輯"
```

---

### Task 9: 完善 UI Game Over 功能

**Files:**
- Modify: `scripts/UI.gd` (確保 Game Over 畫面完整顯示)

- [ ] **Step 1: 調整 GameOverPanel 佈局**

確保 Game Over 畫面在螢幕中央顯示，且背景半透明。

```gdscript
# 在 scripts/UI.gd 的 _ready() 中新增背景設定

func _ready():
	# 設定 GameOverPanel 背景
	game_over_panel.modulate = Color(0, 0, 0, 0.5)
	
	restart_button.pressed.connect(_on_restart_pressed)
```

- [ ] **Step 2: 手動測試 Game Over 畫面**

在 Godot Editor 中：
- 遊戲 Main 場景（F5）
- 撞牆或撞自己觸發 Game Over
- 確認 Game Over 畫面顯示在中央
- 確認 Final Score 正確顯示
- 確認 Restart 按鈕可點擊並重新開始遊戲

- [ ] **Step 3: Commit**

```bash
git add scripts/UI.gd
git commit -m "feat(ui): 完善 Game Over 畫面佈局"
```

---

### Task 10: 設定 Main 場景為主場景

**Files:**
- Modify: `project.godot` (設定 run/main_scene)

- [ ] **Step 1: 在 project.godot 中設定主場景**

```ini
# 在 project.godot 的 [application] 区段新增

[application]

run/main_scene="res://scenes/Main.tscn"
config/name="Snake Game"
```

- [ ] **Step 2: 验证主場景設定**

在 Godot Editor 中：
- 運行專案（F5）會自動開啟 Main.tscn
- 不需手動選擇場景

- [ ] **Step 3: Commit**

```bash
git add project.godot
git commit -m "chore(config): 設定 Main.tscn 為主場景"
```

---

### Task 11: 建立蛇身圓形視覺

**Files:**
- Modify: `scripts/Snake.gd` (繪製圓形蛇身)

- [ ] **Step 1: 使用代碼繪製圓形蛇身**

Godot 的 Sprite2D 需要 texture。我們可以用代碼建立簡單的圓形 texture。

```gdscript
# 在 scripts/Snake.gd 中修改

extends Node2D

var body_sprites: Array = []
var head_sprite: Sprite2D
var cell_size: int = 32

func _ready():
	head_sprite = $Head
	# 建立圓形 texture
	head_sprite.texture = create_circle_texture(cell_size * 0.8, Color(0.2, 0.6, 0.2))
	body_sprites = []

func create_circle_texture(size: float, color: Color) -> ImageTexture:
	var img = Image.create_empty(int(size), int(size), false, Image FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))
	
	# 繪製圓形
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
	# 更新蛇頭位置
	if positions.size() > 0:
		head_sprite.position = Vector2(
			positions[0].x * cell_size + cell_size / 2,
			positions[0].y * cell_size + cell_size / 2
		)
	
	# 更新蛇身
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
```

- [ ] **Step 2: 手動測試圓形蛇身**

在 Godot Editor 中：
- 遊戲 Main 場景（F5）
- 確認蛇頭和蛇身都是圓形而非方形
- 吃食物後蛇身新增圓形 segment

- [ ] **Step 3: Commit**

```bash
git add scripts/Snake.gd
git commit -m "feat(visual): 使用代碼繪製圓形蛇身"
```

---

### Task 12: 建立食物圓形視覺

**Files:**
- Modify: `scripts/Food.gd` (繪製圓形食物)

- [ ] **Step 1: 在 Food.gd 中建立圓形 texture**

```gdscript
# 在 scripts/Food.gd 中修改

extends Sprite2D

var cell_size: int = 32

func _ready():
	texture = create_circle_texture(cell_size * 0.6, Color(1, 0.3, 0.3))
	offset = Vector2(cell_size / 2, cell_size / 2)

func create_circle_texture(size: float, color: Color) -> ImageTexture:
	var img = Image.create_empty(int(size), int(size), false, Image FORMAT_RGBA8)
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

func set_grid_position(grid_pos: Vector2i):
	position = Vector2(grid_pos.x * cell_size, grid_pos.y * cell_size)
```

- [ ] **Step 2: 手動測試圓形食物**

在 Godot Editor 中：
- 遊戲 Main 場景（F5）
- 確認食物是圓形紅色而非方形
- 吃食物後新食物也是圓形

- [ ] **Step 3: Commit**

```bash
git add scripts/Food.gd
git commit -m "feat(visual): 使用代碼繪製圓形食物"
```

---

### Task 13: 加入蛇頭眼睛表情

**Files:**
- Modify: `scripts/Snake.gd` (加入眼睛 Sprite 和表情控制)
- Modify: `scenes/Snake.tscn` (加入 Eyes 子節點)

- [ ] **Step 1: 在 Snake.tscn 中加入 Eyes 節點**

使用 Godot MCP：
```gdscript
# 在 Snake.tscn 中新增 Eyes 結構

[node name="Eyes" type="Node2D" parent="Head"]

[node name="LeftEye" type="Sprite2D" parent="Head/Eyes"]
offset = Vector2(-5, -5)

[node name="RightEye" type="Sprite2D" parent="Head/Eyes"]
offset = Vector2(5, -5)
```

- [ ] **Step 2: 在 Snake.gd 中建立眼睛視覺**

```gdscript
# 在 scripts/Snake.gd 中修改

func _ready():
	head_sprite = $Head
	head_sprite.texture = create_circle_texture(cell_size * 0.8, Color(0.2, 0.6, 0.2))
	
	# 建立眼睛
	var left_eye = $Head/Eyes/LeftEye
	var right_eye = $Head/Eyes/RightEye
	left_eye.texture = create_circle_texture(cell_size * 0.15, Color(1, 1, 1))
	right_eye.texture = create_circle_texture(cell_size * 0.15, Color(1, 1, 1))
	left_eye.offset = Vector2(-5, -5) + Vector2(cell_size * 0.15 / 2, cell_size * 0.15 / 2)
	right_eye.offset = Vector2(5, -5) + Vector2(cell_size * 0.15 / 2, cell_size * 0.15 / 2)
	
	body_sprites = []
```

- [ ] **Step 3: 手動測試眼睛視覺**

在 Godot Editor 中：
- 遊戲 Main 場景（F5）
- 煽蛇頭有兩個白色小眼睛

- [ ] **Step 4: Commit**

```bash
git add scenes/Snake.tscn scripts/Snake.gd
git commit -m "feat(visual): 加入蛇頭眼睛表情"
```

---

### Task 14: 加入食物浮動動畫

**Files:**
- Modify: `scripts/Food.gd` (加入浮動動畫)

- [ ] **Step 1: 在 Food.gd 中加入簡單浮動動畫**

使用 Tween 或 AnimationPlayer 實現浮動效果。我們用簡單的 Tween 方式。

```gdscript
# 在 scripts/Food.gd 中修改

extends Sprite2D

var cell_size: int = 32
var base_position: Vector2

func _ready():
	texture = create_circle_texture(cell_size * 0.6, Color(1, 0.3, 0.3))
	offset = Vector2(cell_size / 2, cell_size / 2)
	start_float_animation()

func start_float_animation():
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(self, "position:y", position.y - 3, 0.5)
	tween.tween_property(self, "position:y", position.y + 3, 0.5)

func set_grid_position(grid_pos: Vector2i):
	base_position = Vector2(grid_pos.x * cell_size, grid_pos.y * cell_size)
	position = base_position
```

- [ ] **Step 2: 手動測試食物浮動動畫**

在 Godot Editor 中：
- 遊戲 Main 場景（F5）
- 確認食物輕微上下浮動

- [ ] **Step 3: Commit**

```bash
git add scripts/Food.gd
git commit -m "feat(animation): 加入食物浮動動畫"
```

---

### Task 15: 最終測試與調整

**Files:**
- None (測試階段)

- [ ] **Step 1: 全面功能測試**

在 Godot Editor 中：
- 遊戲 Main 場景（F5）
- 測試所有核心功能：
  - 方向鍵控制
  - WASD 控制
  - 吃食物增長
  - 分數計算
  - 速度漸進
  - 撞牆 Game Over
  - 撞自己 Game Over
  - 最高分持久化（重啟遊戲後檢查）
  - Restart 功能

- [ ] **Step 2: 調整視覺細節**

如需要：
- 調整蛇頭眼睛位置
- 調整食物浮動幅度
- 調整顏色配色
- 調整 UI 佈局

- [ ] **Step 3: 验證專案運行**

Run: F5 遊戲專案
Expected: 遊戲順暢運行，所有功能正常

---

## Self-Review Checklist

1. **Spec coverage:**
   - ✅ 方向鍵和 WASD 控制：Task 6
   - ✅ 吃食物增長、分數增加：Task 7
   - ✅ 撞牆和撞自己 Game Over：Task 5, Task 8
   - ✅ 速度漸進：Task 7
   - ✅ 分數和最高分顯示：Task 4
   - ✅ 最高分持久化：Task 4
   - ✅ Game Over 畫面和 Restart：Task 4, Task 9
   - ✅ 卡通風格圓形視覺：Task 11, Task 12, Task 13
   - ✅ 眼睛表情：Task 13
   - ✅ 食物浮動動畫：Task 14

2. **Placeholder scan:**
   - ✅ 所有步驟都有實際代碼
   - ✅ 沒有 TBD、TODO、implement later
   - ✅ 每個步驟都有明確的測試指令

3. **Type consistency:**
   - ✅ 所有 Vector2i 使用一致
   - ✅ cell_size = 32 一致
   - ✅ grid_size = Vector2i(20, 20) 一致
   - ✅ 函數名稱一致（update_visuals, set_grid_position 等）