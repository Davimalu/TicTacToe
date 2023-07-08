extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	# Every time "game" is loaded, update the score from the global variable
	get_node(".").text = str(scores.computer_score)


func _on_node_2d_update_labels():
	get_node(".").text = str(scores.computer_score)
