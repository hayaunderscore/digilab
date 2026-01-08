extends Control

func _on_help_pressed() -> void:
	get_viewport().gui_release_focus()
	$Overlay.visible = true


func _on_scene_button_pressed() -> void:
	get_tree().change_scene_to_file("res://objs/home.tscn")
