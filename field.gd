extends Node2D

var is_player_turn = true
var o_field = preload("res://images/o_field.png")
var x_field = preload("res://images/x_field.png")

# Initialize variable that will store the field
var game_field = ["", "", "", "", "", "", "", "", ""]

func player_turn(field):
	# If it's not the player's turn, alert him and abort
	if not is_player_turn:
		OS.alert("It's not your turn!", "Invalid move")
		return 1
	
	# Check for valid move - is the field already occupied?
	if not game_field[field] == "":
		OS.alert("This field is already occupied!", "Invalid move")
		return 1
	
	# Construct path name
	var path = "0" + str(field) + "Area2D/0" + str(field) + "Sprite"
	# Get sprite from path name
	var sprite = get_node(path)
	# Change texture to X
	sprite.set_texture(x_field)
	
	# Update field in array
	game_field[field] = "X"
	
	# Wait for a small period of time before calling check_winner to allow the sprite being updated
	await get_tree().create_timer(0.1).timeout
	
	# Check for winner - if no winner is found, it's the AI's turn
	var winner_name = check_winner()
	if not winner_name:
		is_player_turn = false
		ai_turn()
	else:
		winner(winner_name)

func check_winner():
	# Check for every situation where one of the players won
	
	# 3 in each row
	if game_field[0] == game_field[1] and game_field[1] == game_field[2] and not game_field[0] == "":
		return game_field[0]
	if game_field[3] == game_field[4] and game_field[4] == game_field[5] and not game_field[3] == "":
		return game_field[3]
	if game_field[6] == game_field[7] and game_field[7] == game_field[8] and not game_field[6] == "":
		return game_field[6]

	# 3 in each column
	if game_field[0] == game_field[3] and game_field[3] == game_field[6] and not game_field[0] == "":
		return game_field[0]
	if game_field[1] == game_field[4] and game_field[4] == game_field[7] and not game_field[1] == "":
		return game_field[1]
	if game_field[2] == game_field[5] and game_field[5] == game_field[8] and not game_field[2] == "":
		return game_field[2]

	# Diagonals
	if game_field[0] == game_field[4] and game_field[4] == game_field[8] and not game_field[0] == "":
		return game_field[0]
	if game_field[2] == game_field[4] and game_field[4] == game_field[6] and not game_field[2] == "":
		return game_field[2]
	
	# If there are no more empty fields and nobody has won, it's a tie
	var tie = 0
	for field in game_field:
		if field == "":
			tie += 1
	if tie == 0:
		return "Tie"
	
	# If none of these is the case, return false
	return false


func winner(player_name):
	# Update global player_score or computer_score variable and alert the player
	if player_name == "Tie":
		scores.player_score += 1
		scores.computer_score += 1
		OS.alert("It's a tie!", "Round End!")
	else:
		if player_name == "X":
			scores.player_score += 1
		else:
			scores.computer_score += 1
		OS.alert(str(player_name) + " has won", "Round End!")
		
	# Restart the game and add points
	get_tree().change_scene_to_file("res://game.tscn")

func ai_turn():
	var ai_move = false
	# Each scenario is sorted according to its importance
	# E.g. if a winning move is found, it is no longer relevant to block the player
	
	# If it is possible to win, make that turn
	# Iterate through each possible move | Use check_winner() function to see if that would lead to a win
	for i in 9:
		# If the field is already occupied, skip it
		if not game_field[i] == "":
			continue

		game_field[i] = "O"
		var temp_winner = check_winner()
		# If check_winner returns the boolean false, don't bother
		if temp_winner:
			# If a winning_move is determined, save that move in ai_move
			if temp_winner == "O":
				ai_move = i
		game_field[i] = ""
	
	# If AI can prevent the player form winning, make that turn
	# Use same logic as above, just reverted
	if ai_move is bool:
		for i in 9:
			# If the field is already occupied, skip it
			if not game_field[i] == "":
				continue

			game_field[i] = "X"
			var temp_winner = check_winner()
			# If check_winner returns the boolean false, don't bother
			if temp_winner:
				# If a winning_move for the player is determined, save it in ai_move
				# Then, have the AI make that move, to block the player
				if temp_winner == "X":
					ai_move = i
			game_field[i] = ""
	
	# Else, make a random move
	if ai_move is bool:
		while ai_move is bool:
			var rng = RandomNumberGenerator.new()
			ai_move = rng.randi_range(0, 8)
			if not game_field[ai_move] == "":
				ai_move = false
	
	# Update sprite
	# Construct path name
	var path = "0" + str(ai_move) + "Area2D/0" + str(ai_move) + "Sprite"
	# Get sprite from path name
	var sprite = get_node(path)
	# Change texture to X
	sprite.set_texture(o_field)
	
	# Update field in array
	game_field[ai_move] = "O"
	
	# Wait for a small period of time before calling check_winner to allow the sprite being updated
	await get_tree().create_timer(0.1).timeout
	
	var winner_name = check_winner()
	if not check_winner():
		pass
	else:
		winner(winner_name)
	
	is_player_turn = true

# Button click events | Each button click leads to player_turn() being executed
# The field number is passed as argument
func _ready():
	for i in 9:
		# Construct name of game obejct
		var Area2D_name = "0" + str(i) + "Area2D"
		# Get that game object
		var Area2D_object = get_node(Area2D_name)
		# The .bind() method allows to pass in another argument
		# See https://docs.godotengine.org/en/stable/classes/class_object.html#class-object-method-connect 
		Area2D_object.input_event.connect(on_button_click.bind(i))

func on_button_click(_viewport, event, _shape_idx, button_index):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			player_turn(button_index)
