extends Control

@onready var scenario_label: Label = $VBoxContainer/ScenarioPanel/ScenarioLabel
@onready var feedback_label: Label = $VBoxContainer/FeedbackLabel
@onready var next_button: Button = $VBoxContainer/NextButton
@onready var score_label: Label = $VBoxContainer/ScoreLabel
@onready var buttons_container: HBoxContainer = $VBoxContainer/ButtonsContainer

var emotion_buttons: Array = []

func _ready():
	# Create emotion buttons dynamically
	var emotions = ["Happy", "Sad", "Angry", "Scared", "Excited"]
	
	for emotion in emotions:
		var btn = Button.new()
		btn.text = emotion
		btn.custom_minimum_size = Vector2(100, 50)
		btn.pressed.connect(_on_emotion_pressed.bind(emotion))
		buttons_container.add_child(btn)
		emotion_buttons.append(btn)
	
	next_button.pressed.connect(_on_next_pressed)
	next_button.visible = false
	
	load_scenario()

func load_scenario():
	if Global.current_question_index >= Global.questions.size():
		# Game Over, go to victory screen
		get_tree().change_scene_to_file("res://scenes/VictoryScreen.tscn")
		return
	
	var q_data = Global.questions[Global.current_question_index]
	scenario_label.text = "Story " + str(Global.current_question_index + 1) + ":\n\n" + q_data.scenario
	feedback_label.text = ""
	feedback_label.modulate = Color.WHITE
	next_button.visible = false
	
	# Enable buttons
	for btn in emotion_buttons:
		btn.disabled = false
	
	update_score_display()

func _on_emotion_pressed(emotion: String):
	var q_data = Global.questions[Global.current_question_index]
	
	# Disable all buttons
	for btn in emotion_buttons:
		btn.disabled = true
	
	if emotion == q_data.correct_emotion:
		feedback_label.text = "Great job! " + emotion + " is correct!"
		feedback_label.modulate = Color.GREEN
		Global.empathy_score += 100
	else:
		feedback_label.text = "Not quite. The feeling was " + q_data.correct_emotion + "."
		feedback_label.modulate = Color.ORANGE
	
	next_button.visible = true
	update_score_display()

func _on_next_pressed():
	Global.current_question_index += 1
	load_scenario()

func update_score_display():
	score_label.text = "Empathy Score: " + str(Global.empathy_score)