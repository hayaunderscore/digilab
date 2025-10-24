extends Node2D

# this is all in english im sorry if you dont understand run it through google translate or smth idk

# GDScript is the main language of Godot. Think Python but also not python
# Most programming concepts are applicable here, like variables, types, functions, etc.
# Compared to C++, GDScript does not require compilation, 
# as that is done at runtime, when the game is launched.

# This is a script, a code file that determines how something should act.
# Most scripts are generally attached to a scene- which can hold other scenes.
# A scene has a list of nodes- which can also be other scenes.
# Think of each individual pot scene as a new pot with its own values not related to each other
# so no pot is *exactly* the same

# Export variable - sunlight, holds a floating-point number (decimals) from 0-100
# Export variables are editable in an editor for each instance of this object
@export var sunlight: float = 50
@export var water: float = 50
# Unused for now
@export var target_final_time: float = 200

var state: int = 0 # Current state of the sprout
var time: float = 0 # Current time before the next state- resets when the state is changed
var true_time: float = 0 # Real time

var started: bool = false # Whether it has started its cycle or not

const HEALTHY_FRAME: int = 5 # Constant- never changes. The state that a plant is considered 'healthy' and slows down the growth
var BASE_SPEED: float = 3 # Base speed, in seconds

# Regions and stuff for the visual aspect
@onready var sprout: Sprite2D = $Sprout
@onready var tex: Texture2D = $Sprout.texture
@onready var region: Rect2 = $Sprout.region_rect
@onready var max_states: int = floor(tex.get_width() / region.size.x)

var speed: float = 1 # Speed multiplier for the sprout state changing

# Runs when this object is created in the scene.
func _ready() -> void:
	$Control/SunlightSlider/HSlider.value = sunlight
	$Control/WaterSlider/HSlider.value = water

# Runs every "physics frame"
# Runs basically when the program runs. 
# It goes on forever, until the object is removed, or the program is closed.
func _physics_process(delta: float) -> void:
	if started:
		time += delta * speed
		# normal time variable resets after sunlight state advances
		true_time += delta * speed
	
		# Check the time
		# We advance, depending on the state of affairs
		# Sunlight contributes how fast the plant grows
		# Water contributes how the plant sustains its final form
		if time >= BASE_SPEED * (0.2 + (1 - (sunlight / 100))):
			# Reset time...
			time = 0
			# Advance state!
			state = mini(state + 1, max_states - 1)
			# Update sprite to account for this!
			sprout.region_rect.position.x = state * region.size.x
		
		# Und ve are now in the healthy state
		# Reduce the speed based on water amt
		if time < (delta * speed) and state == HEALTHY_FRAME:
			print("slowing down...")
			speed = speed * maxf(0.1, (1 - (water / 100)))
	
	pass

# Slides that modify the values of this pot.
# UI elements can be attached to this pot.
# Explanation on signals (the way a slider interacts with this script, for example) are in world.gd
func _on_sunlight_value_changed(value: float) -> void:
	$Control/SunlightSlider/HSlider/Label.text = "%02d" % [value]
	sunlight = value

func _on_water_value_changed(value: float) -> void:
	$Control/WaterSlider/HSlider/Label.text = "%02d" % [value]
	water = value

# Starts the sprouting cycle
func start(_speed: float = 3):
	started = true
	$Control.visible = false
	BASE_SPEED = _speed

# Resets the sprout back to its normal, nonexistent form
func reset():
	started = false
	$Control.visible = true
	sprout.region_rect.position.x = 0
	true_time = 0
	time = 0
	state = 0
	speed = 1

# Pauses the sprouting cycle
func pause():
	started = false
	$Control.visible = true
	
