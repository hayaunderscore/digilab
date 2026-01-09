extends TextureRect

# Existing exports/variables for momentum
@export var friction: float = 0.9  # How quickly momentum slows down (0-1)
@export var lerp_speed: float = 0.5  # Dragging smoothness (0-1, higher = snappier)

# New exports for pouring
@export var glass_plain: Node2D
@export var glass_salt: Node2D

# Combined variables
var poured := false
var dragging := false
var drag_offset := Vector2.ZERO
var velocity := Vector2.ZERO  # For momentum (from existing)

func _ready():
	pass  # _process is enabled by default

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			drag_offset = get_viewport().get_mouse_position() - global_position  # Adjusted to global for consistency
			velocity = Vector2.ZERO  # Reset velocity (from existing)
			get_parent().move_child(self, -1)  # Bring to front (from existing)
		else:
			dragging = false
			if not poured:  # New: Pour on release if not already poured
				_pour_water()

func _process(delta):
	if dragging:
		var mouse_pos = get_viewport().get_mouse_position()
		var target_pos = mouse_pos - drag_offset
		
		# Optional: Clamp to viewport bounds (from existing, adjusted to global)
		var viewport_size = get_viewport_rect().size
		target_pos.x = clamp(target_pos.x, 0, viewport_size.x - size.x)
		target_pos.y = clamp(target_pos.y, 0, viewport_size.y - size.y)
		
		# Smooth interpolation (from existing)
		global_position = global_position.lerp(target_pos, lerp_speed)  # Changed to global_position
		
		# Update velocity for momentum (from existing)
		velocity = (target_pos - global_position) / delta  # Adjusted to global
	else:
		# Apply momentum after release (from existing)
		if velocity.length() > 1:
			global_position += velocity * delta  # Adjusted to global
			velocity *= friction
		   
# New function for pouring
func _pour_water():
	var plain_water = get_parent().get_node("WaterFillPlain")
	var salt_water  = get_parent().get_node("WaterFillSalt")

	plain_water.visible = true
	salt_water.visible = true

	poured = true
