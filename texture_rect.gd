extends TextureRect

var dragging = false
var drag_offset = Vector2.ZERO

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Start dragging
				dragging = true
				drag_offset = event.position - position
				# Optional: Raise to top (for overlapping icons)
				get_parent().move_child(self, -1)
			else:
				# Stop dragging
				dragging = false
	elif event is InputEventMouseMotion and dragging:
		# Update position during drag
		position = event.position - drag_offset
