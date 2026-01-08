extends TextureRect

var dragging = false
var drag_offset = Vector2.ZERO
var velocity = Vector2.ZERO  # For momentum (optional)
var friction = 0.9  # How quickly momentum slows down

func _ready():
	set_process(true)

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				drag_offset = get_viewport().get_mouse_position() - position
				velocity = Vector2.ZERO
				get_parent().move_child(self, -1)
			else:
				dragging = false

func _process(delta):
	if dragging:
		var mouse_pos = get_viewport().get_mouse_position()
		var target_pos = mouse_pos - drag_offset
		
		# Smooth interpolation (adjust 0.5 for speed: higher = faster following)
		position = position.lerp(target_pos, 0.5)
		
		# For instant following (no easing), uncomment this instead:
		# rect_position = target_pos
		
		# Update velocity for momentum
		velocity = (target_pos - position) / delta
	else:
		# Apply momentum after release
		if velocity.length() > 1:
			position += velocity * delta
			velocity *= friction
