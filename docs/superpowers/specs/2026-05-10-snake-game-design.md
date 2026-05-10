# Snake Game - Design Document

## 概述

開發一個經典貪吃蛇遊戲，使用 Godot 4.2.2。採用卡通可愛風格、漸進加速難度、支援方向鍵和 WASD 控制。

## 核心玩法

- 方向鍵或 WASD 控制蛇移動方向
- 吃到食物蛇身變長、分數增加
- 撞牆或撞到自己則 Game Over
- 每吃一個食物速度漸進加快
- 顯示當前分數和最高分

## 設計風格

- **卡通可愛風格**：圓潤造型、眼睛表情、鮮豔色彩
- **蛇頭**：帶眼睛表情動畫（眨眼、開心、驚恐）
- **蛇身**：圓形分段、流暢動畫
- **食物**：圓潤水果造型、輕微浮動動畫

## 系統架構

```
Main (Node2D)
├── GameManager (Node)
│   ├── 蛇移動邏輯
│   ├── 碰撞檢測
│   ├── 分數計算
│   └── 遊戲狀態管理
│
├── Snake (Node2D)
│   ├── Head (Sprite2D + Animation)
│   └── Body segments (Array<Sprite2D>)
│
├── Food (Sprite2D + Animation)
│
└── UI (CanvasLayer)
    ├── ScoreLabel
    ├── HighScoreLabel
    └── GameOverScreen
```

### Grid System

- 20x20 格子地圖
- 每格 32x32 pixels
- 所有物件對齊格子移動

## 組件設計

### GameManager

**屬性**
- `grid_size: Vector2i = Vector2i(20, 20)` - 地圖格子數
- `cell_size: int = 32` - 每格像素
- `snake_position: Array[Vector2i]` - 蛇的所有格子位置
- `food_position: Vector2i` - 食物格子位置
- `direction: Vector2i = Vector2i.RIGHT` - 移動方向
- `score: int = 0` - 當前分數
- `high_score: int = 0` - 最高分（持久化存檔）
- `base_speed: float = 0.2` - 基礎移動間隔（秒）
- `current_speed: float` - 當前速度（隨分數加快）
- `move_timer: Timer` - 移動計時器
- `is_game_over: bool = false` - 遊戲狀態

**方法**
- `reset_game()` - 重置遊戲狀態
- `move()` - 蛇移動邏輯
- `check_collision()` - 碰撞檢測
- `spawn_food()` - 生成新食物
- `update_speed()` - 根據分數調整速度
- `game_over()` - 遊戲結束處理
- `load_high_score()` - 載入最高分
- `save_high_score()` - 儲存最高分

### Snake

**屬性**
- `body_sprites: Array[Sprite2D]` - 蛇身 Sprite 陣列
- `head_sprite: Sprite2D` - 蛇頭 Sprite
- `eye_animation_player: AnimationPlayer` - 眼睛表情動畫

**方法**
- `update_visuals(positions: Array[Vector2i])` - 更新蛇身視覺位置
- `play_expression(type: String)` - 播放表情動畫（"blink", "happy", "scared"）

### Food

**屬性**
- `sprite: Sprite2D` - 食物 Sprite
- `float_animation: AnimationPlayer` - 浮動動畫

**方法**
- `set_position(grid_pos: Vector2i)` - 設定格子位置
- `play_eaten_effect()` - 被吃時消失特效

### UI

**屬性**
- `score_label: Label` - 分數顯示 "Score: 0"
- `high_score_label: Label` - 最高分顯示 "High Score: 0"
- `game_over_panel: Control` - Game Over 畫面
- `restart_button: Button` - 重新開始按鈕

**方法**
- `update_score(score: int)` - 更新分數顯示
- `update_high_score(high_score: int)` - 更新最高分顯示
- `show_game_over(final_score: int)` - 顯示 Game Over 畫面
- `hide_game_over()` - 隱藏 Game Over 畫面

## 資料流程

### 遊戲啟動

```
Main._ready()
  → GameManager.load_high_score()
  → GameManager.reset_game()
    → 蛇初始化在中央 [(10,10)]
    → spawn_food() 隨機生成食物
    → current_speed = base_speed
  → UI.update_score(0)
  → UI.update_high_score(high_score)
  → 開始 Timer，等待輸入
```

### 每回合移動

```
Timer.timeout
  → GameManager.move()
    → new_head = snake_position[0] + direction
    → check_collision(new_head)
      → 撞牆？ → game_over()
      → 撞自己？ → game_over()
      → 撞到食物？
        → snake_position.insert(0, new_head)
        → score += 1
        → spawn_food()
        → update_speed()
        → Snake.play_expression("happy")
      → 正常移動
        → snake_position.insert(0, new_head)
        → snake_position.pop_back()
    → Snake.update_visuals(snake_position)
    → UI.update_score(score)
```

### 輸入處理

```
GameManager._input(event)
  → 檢查是否為方向鍵或 WASD
  → 檢查是否與當前方向相反
    → 若相反則拒絕（不能直接回頭）
  → 更新 direction
```

### 速度漸進公式

```gdscript
current_speed = base_speed - (score * 0.005)
current_speed = max(current_speed, 0.05)  # 最小速度限制
```

每吃一個食物，速度加快 0.005 秒，最快 0.05 秒移動一次。

## 錯誤處理

### 碰撞檢測

- **撞牆**：蛇頭超出 grid_bounds → `game_over()`
- **撞自己**：蛇頭與任一蛇身位置重疊 → `game_over()`

### 輸入限制

- **防止反向移動**：若新方向與當前方向相反 → 拒絕更新
- **遊戲結束禁用輸入**：is_game_over = true 時不接受輸入

### 資料持久化

- 存檔路徑：`user://high_score.save`
- 格式：JSON `{ "high_score": int }`
- 檔案不存在或格式錯誤 → 預設為 0

### 食物生成邊界

- 確保食物不生成在蛇身上
- 蛇身最大長度：grid_size.x * grid_size.y - 1（填滿地圖減一格）

## 測試計畫

### 核心功能測試

1. **移動正確性**
   - 方向鍵控制蛇移動方向
   - WASD 控制蛇移動方向
   - 蛇頭對齊格子位置

2. **吃食物**
   - 蛇身增長一格
   - 分數增加 1
   - 新食物生成在非蛇身位置
   - 速度加快

3. **碰撞檢測**
   - 撞左/右/上/下牆 → Game Over
   - 撞自己 → Game Over
   - Game Over 顯示正確畫面

4. **速度漸進**
   - 隨分數增加速度加快
   - 速度有最小限制

### UI 測試

1. **分數顯示**
   - Score 正確更新
   - High Score 正確顯示
   - Game Over 顯示 Final Score

2. **最高分持久化**
   - 遊戲結束時更新最高分
   - 重啟遊戲後保留最高分
   - 檔案不存在時預設為 0

3. **Game Over 畫面**
   - 正確顯示
   - Restart 按鈕功能正常
   - 隱藏後可重新開始

### 輸入測試

1. **控制支援**
   - 方向鍵 ↑↓←→ 能控制
   - WASD 能控制

2. **反向移動防護**
   - 左→右 拒絕
   - 上→下 拒絕
   - 右→左 拒絕
   - 下→上 拒絕

3. **遊戲狀態**
   - 遊戲結束時輸入禁用
   - Restart 後輸入恢復

## 檔案結構

```
snake.godot/
├── scenes/
│   ├── Main.tscn - 主場景
│   ├── Snake.tscn - 蛇場景（Prefab）
│   └── Food.tscn - 零食場景（Prefab）
│
├── scripts/
│   ├── GameManager.gd - 遊戲邏輯
│   ├── Snake.gd - 蛇視覺更新
│   ├── Food.gd - 零食行為
│   └── UI.gd - UI 管理
│
├── assets/
│   ├── sprites/
│   │   ├── snake_head.png - 蛇頭（帶眼睛）
│   │   ├── snake_body.png - 蛇身圓形
│   │   ├── food_apple.png - 食物（圓潤造型）
│   │
│   └── animations/
│       ├── blink.tres - 眨眼動畫
│       ├── happy.tres - 開心表情
│       ├── scared.tres - 驚恐表情
│       ├── float.tres - 食物浮動
│       ├── eaten.tres - 被吃特效
│
├── docs/
│   └── superpowers/
│       └ specs/
│         └ 2026-05-10-snake-game-design.md
│
└── project.godot
```

## 技術決策

### Node2D vs TileMap

選擇 Node2D + Grid 系統而非 TileMap：
- TileMap 需自訂 TileSet，動畫控制複雜
- Node2D 更適合卡通風格、表情動畫
- Sprite2D 可自由控制位置、旋轉、動畫
- 開發效率高、易於維護

### Timer vs Process

選擇 Timer 控制移動而非 _process()：
- Timer 確保固定時間間隔移動（格子對齊）
- _process() 每帧調用，難以控制精確時間
- Timer 可動態調整 wait_time 現現速度漸進

### 資料持久化

使用 Godot 內建 `user://` 路徑：
- 跨平台兼容（Windows/Mac/Linux）
- 不需額外權限
- FileAccess API 簡單易用

## 開發順序建議

1. 建立基本場景結構（Main, Snake, Food, UI）
2. 實作 GameManager 核心邏輯（移動、碰撞）
3. 實作輸入處理
4. 實作吃食物邏輯
5. 實作速度漸進
6. 實作 UI 顯示
7. 實作最高分持久化
8. 實作 Game Over 和 Restart
9. 加入視覺動畫（表情、浮動）
10. 測試與調整

## 成功標準

- 蛇移動流暢、格子對齊
- 吃食物、碰撞檢測正確
- 速度漸進平滑
- 最高分持久化可靠
- UI 清晰易讀
- 卡通風格可愛活潑
- 方向鍵和 WASD 都能順暢控制