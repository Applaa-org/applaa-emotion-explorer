extends Node

# Game State
var empathy_score: int = 0
var player_name: String = "Explorer"
var current_question_index: int = 0
var high_score: int = 0
var game_id: String = "emotion-explorer"

# Questions Database
var questions: Array = [
	{
		"scenario": "Sarah drops her ice cream cone on the ground. It was her favorite flavor.",
		"correct_emotion": "Sad",
		"options": ["Happy", "Sad", "Angry", "Scared", "Excited"]
	},
	{
		"scenario": "Tom sees a puppy wagging its tail and running towards him.",
		"correct_emotion": "Excited",
		"options": ["Happy", "Sad", "Angry", "Scared", "Excited"]
	},
	{
		"scenario": "Mia hears a loud thunderstorm outside her window at night.",
		"correct_emotion": "Scared",
		"options": ["Happy", "Sad", "Angry", "Scared", "Excited"]
	},
	{
		"scenario": "Sam's brother breaks his favorite toy without asking.",
		"correct_emotion": "Angry",
		"options": ["Happy", "Sad", "Angry", "Scared", "Excited"]
	},
	{
		"scenario": "Leo finds out he is going to the amusement park tomorrow!",
		"correct_emotion": "Excited",
		"options": ["Happy", "Sad", "Angry", "Scared", "Excited"]
	}
]

# Reset game state for a new session
func reset_game():
	empathy_score = 0
	current_question_index = 0

# Calculate badge based on score
func get_badge() -> String:
	var percentage: float = float(empathy_score) / (questions.size() * 100) * 100
	if percentage >= 100:
		return "🏆 Master of Feelings"
	elif percentage >= 60:
		return "🌟 Empathy Expert"
	else:
		return "🔍 Novice Explorer"

# Save score to localStorage via Applaa API
func save_score_to_storage():
	# Update high score if current score is higher
	if empathy_score > high_score:
		high_score = empathy_score
	
	# Call JavaScript to save
	JavaScriptBridge.eval("""
		window.parent.postMessage({
			type: 'applaa-game-save-score',
			gameId: '%s',
			playerName: '%s',
			score: %d
		}, '*');
	""" % [game_id, player_name, empathy_score])

# Request game data from localStorage
func load_game_data():
	JavaScriptBridge.eval("""
		window.parent.postMessage({
			type: 'applaa-game-load-data',
			gameId: '%s'
		}, '*');
	""" % game_id)

# This function is called by the JavaScript bridge when data is loaded
func on_data_loaded(data: Dictionary):
	if data.has("highScore"):
		high_score = data.highScore
	if data.has("lastPlayerName"):
		player_name = data.lastPlayerName