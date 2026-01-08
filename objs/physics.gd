extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_exp_1_pressed() -> void:
	get_tree().change_scene_to_file("res://objs/phy_exp_1.tscn")
	


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://objs/experiment.tscn")
<<<<<<< Updated upstream
=======
	


func _on_exp_2_pressed() -> void:
	get_tree().change_scene_to_file("res://objs/phy_exp_2.tscn")
>>>>>>> Stashed changes
