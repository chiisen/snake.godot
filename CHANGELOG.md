# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Snake 遊戲核心功能
  - 20x20 格子地圖，每格 32x32 pixels
  - 卡通風格蛇身與食物（圓形造型、眼睛表情）
  - 食物浮動動畫效果
  - 方向鍵 + WASD 控制
  - 分數顯示與最高分持久化
  - 漸進式加速難度（每吃一個食物速度加快）
  - 遊戲結束畫面與重新開始功能

### Fixed
- 修正 GameManager 節點初始化競態問題 (2026-05-10)
  - 使用 `await get_tree().process_frame` 確保節點初始化
  - 在 `update_game()` 和 `game_over()` 添加 null 檢查
  - Snake.gd `update_visuals()` 添加 head_sprite null 檢查

## [0.1.0] - 2026-05-10

### Added
- Initial project setup
- Godot 4.2.2 project structure
- Basic game architecture design