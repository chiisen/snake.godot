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