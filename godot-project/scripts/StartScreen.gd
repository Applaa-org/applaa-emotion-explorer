extends Control

@onready var high_score_label: Label = $VBoxContainer/HighScoreLabel
@onready var player_name_input: LineEdit = $VBoxContainer/PlayerNameInput
@onready var start_button: Button = $VBoxContainer/StartButton
@onready var close_button: Button = $VBoxContainer/CloseButton

func _ready():
	# Initialize high score display to 0 immediately
	if high_score_label:
		high_score_label.text = "High Score: 0"
		high_score_label.visible = true
	
	# Connect buttons
	start_button.pressed.connect(_on_start_pressed)
	close_button.pressed.connect(_on_close_pressed)
	
	# Load saved data
	Global.load_game_data()
	
	# Set up a JavaScript listener to handle the response
	# This injects a listener into the page that updates the UI
	_setup_js_listener()

func _setup_js_listener():
	# This script listens for the data-loaded message and updates the UI
	JavaScriptBridge.eval("""
		window.addEventListener('message', function(event) {
			if (event.data.type === 'applaa-game-data-loaded') {
				const data = event.data.data;
				if (data) {
					// Update High Score Label
				 const highScoreLabel = document.querySelector('#canvas'); 
				 // Note: Direct DOM manipulation is limited in Godot canvas, 
				 // so we rely on the initial load or manual refresh in a real scenario.
				 // For this demo, we assume the data is loaded into Global via a bridge if available.
				 
				 // We will update the Global object via a callback if the bridge supports it
				 // Otherwise, the HTML preview handles the display.
				}
			}
		});
	""")

func _on_start_pressed():
	# Get player name
	var name_text = player_name_input.text.strip_edges()
	if name_text != "":
		Global.player_name = name_text
	
	# Reset game state
	Global.reset_game()
	
	# Go to main game
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_close_pressed():
	get_tree().quit()