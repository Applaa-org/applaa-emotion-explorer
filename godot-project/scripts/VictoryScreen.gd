extends Control

@onready var badge_label: Label = $VBoxContainer/BadgeLabel
@onready var score_label: Label = $VBoxContainer/ScoreLabel
@onready var high_score_label: Label = $VBoxContainer/HighScoreLabel
@onready var restart_button: Button = $VBoxContainer/RestartButton
@onready var menu_button: Button = $VBoxContainer/MenuButton
@onready var close_button: Button = $VBoxContainer/CloseButton

func _ready():
	# Save the score to localStorage
	Global.save_score_to_storage()
	
	# Display results
	badge_label.text = "Badge Earned:\n" + Global.get_badge()
	score_label.text = "Your Score: " + str(Global.empathy_score)
	
	# Show high score
	if Global.empathy_score >= Global.high_score:
		high_score_label.text = "New High Score: " + str(Global.empathy_score)
		high_score_label.modulate = Color.GOLD
	else:
		high_score_label.text = "High Score: " + str(Global.high_score)
		high_score_label.modulate = Color.WHITE
	
	# Connect buttons
	restart_button.pressed.connect(_on_restart_pressed)
	menu_button.pressed.connect(_on_menu_pressed)
	close_button.pressed.connect(_on_close_pressed)

func _on_restart_pressed():
	Global.reset_game()
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_menu_pressed():
	Global.reset_game()
	get_tree().change_scene_to_file("res://scenes/StartScreen.tscn")

func _on_close_pressed():
	get_tree().quit()