extends Node2D

# Define how many rounds one person needs to win, to win the whole game
const PLAY_TO = 3

# Signal to update the labels
signal update_labels()

# Called when the node enters the scene tree for the first time.
func _ready():
	# If the player or the computer has won, end the game and exit to main menu
	# If both are tied at a number higher than 3, first won to score wins
	if scores.player_score > PLAY_TO - 1 and not scores.computer_score >= scores.player_score:
		# Update labels
		emit_signal("update_labels")
		# Wait for a small period of time to allow the labels to update
		await get_tree().create_timer(0.1).timeout
		OS.alert("You have won the game!", "Game End!")
		reset_game()
		return
	if scores.computer_score > PLAY_TO - 1 and not scores.player_score >= scores.computer_score:
		# Update labels
		emit_signal("update_labels")
		# Wait for a small period of time to allow the labels to update
		await get_tree().create_timer(0.1).timeout
		OS.alert("You have lost the game!", "Game End!")
		reset_game()
		return

func reset_game():
	scores.player_score = 0
	scores.computer_score = 0
	get_tree().change_scene_to_file("res://main.tscn")
