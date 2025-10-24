extends Control

func _on_help_pressed() -> void:
	get_viewport().gui_release_focus()
	$Overlay.visible = true
