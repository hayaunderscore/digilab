extends Node2D

# Preload images grouped by color
var color_images = {
	"no_color": [preload("res://assets/experiments/pechay-no-bg/no_color-removebg.png")],
	"red": [
		preload("res://assets/experiments/pechay-no-bg/red-removebg-1.png"),
		preload("res://assets/experiments/pechay-no-bg/red-removebg-2.png"),
		preload("res://assets/experiments/pechay-no-bg/red-removebg-3.png")
	],
	"blue": [
		preload("res://assets/experiments/pechay-no-bg/blue-removebg-1.png"),
		preload("res://assets/experiments/pechay-no-bg/blue-removebg-2.png"),
		preload("res://assets/experiments/pechay-no-bg/blue-removebg-3.png")
	],
	"orange": [
		preload("res://assets/experiments/pechay-no-bg/orange-removebg-1.png"),
		preload("res://assets/experiments/pechay-no-bg/orange-removebg-2.png"),
		preload("res://assets/experiments/pechay-no-bg/orange-removebg-3.png")
	]
}

# References to nodes
@onready var button1: Button = $button1  # For no_color
@onready var button2: Button = $button2  # For red
@onready var button3: Button = $button3  # For blue
@onready var button4: Button = $button4  # For orange
@onready var start_button: Button = $Start
@onready var restart_button: Button = $Restart
@onready var sprite: Sprite2D = $NoColor
@onready var cycle_timer: Timer = $CycleTimer

# Variables for cycling
var current_color: String = "no_color"  # Default color
var cycle_index: int = 0
var cycle_count: int = 0
const MAX_CYCLES: int = 2  # Change 2 times (show image 2 and 3)

func _ready() -> void:
	# Connect manual buttons
	if button1:
		button1.pressed.connect(_on_button1_pressed)
	else:
		push_error("button1 not found!")
	
	if button2:
		button2.pressed.connect(_on_button2_pressed)
	else:
		push_error("button2 not found!")
	
	if button3:
		button3.pressed.connect(_on_button3_pressed)
	else:
		push_error("button3 not found!")
	
	if button4:
		button4.pressed.connect(_on_button4_pressed)
	else:
		push_error("button4 not found!")
	
	# Connect start and restart buttons
	if start_button:
		start_button.pressed.connect(_on_start_pressed)
	else:
		push_error("Start button not found!")
	
	if restart_button:
		restart_button.pressed.connect(_on_restart_pressed)
	else:
		push_error("Restart button not found!")
	
	if cycle_timer:
		cycle_timer.timeout.connect(_on_cycle_timer_timeout)
	else:
		push_error("CycleTimer not found!")
	
	# Set default image
	if sprite and color_images[current_color].size() > 0:
		sprite.texture = color_images[current_color][0]
	else:
		push_error("NoColor (sprite) not found!")

func _on_start_pressed() -> void:
	# Start auto-cycling for the current color's images
	var current_images = color_images[current_color]
	if current_images.size() <= 1:
		print("No cycling needed for ", current_color, " (only 1 image).")
		return
	
	cycle_count = 0
	cycle_index = 0
	cycle_timer.start()
	print("Auto-cycle started for ", current_color, "!")

func _on_restart_pressed() -> void:
	# Stop the timer, reset to first image, reset counters (do not start cycle)
	cycle_timer.stop()
	cycle_index = 0
	cycle_count = 0
	if sprite and color_images[current_color].size() > 0:
		sprite.texture = color_images[current_color][0]
	print("Restarted: Back to first image of ", current_color, ". Cycle stopped.")

func _on_cycle_timer_timeout() -> void:
	var current_images = color_images[current_color]
	if cycle_count < MAX_CYCLES and current_images.size() > 1:
		cycle_index = (cycle_index + 1) % current_images.size()
		sprite.texture = current_images[cycle_index]
		cycle_count += 1
		print("Auto-changed to ", current_color, " image: ", current_images[cycle_index].resource_path)
	else:
		cycle_timer.stop()
		print("Auto-cycle stopped for ", current_color, " after 2 changes.")

# Manual button functions (set color and show first image)
func _on_button1_pressed() -> void:
	current_color = "no_color"
	if sprite:
		sprite.texture = color_images[current_color][0]
		print("Selected no_color: ", color_images[current_color][0].resource_path)

func _on_button2_pressed() -> void:
	current_color = "red"
	if sprite:
		sprite.texture = color_images[current_color][0]
		print("Selected red: ", color_images[current_color][0].resource_path)

func _on_button3_pressed() -> void:
	current_color = "blue"
	if sprite:
		sprite.texture = color_images[current_color][0]
		print("Selected blue: ", color_images[current_color][0].resource_path)

func _on_button4_pressed() -> void:
	current_color = "orange"
	if sprite:
		sprite.texture = color_images[current_color][0]
		print("Selected orange: ", color_images[current_color][0].resource_path)
