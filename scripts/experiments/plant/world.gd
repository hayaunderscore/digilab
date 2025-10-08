extends Node2D

# For an explanation on scenes, check pot.gd

# This scene contains buttons.
# Buttons are objects that have signals- these signals can be connected to the object's
# functions through a script.

# In this case, all buttons in this scene do something when pressed
# Once the button is pressed, it emits a signal
# A script can then receive that signal, and do something with it

# mhgkhjfghnf pots
@onready var pots: Node2D = $Environment/Pots

# This starts the sprouting 
func _on_start_button_pressed() -> void:
	# This goes through every pot in the scene.
	# All pots are contained within a node, for organization.
	for pot in pots.get_children():
		# Start each pot
		pot.start()

func _on_pause_button_pressed() -> void:
	for pot in pots.get_children():
		pot.pause()

func _on_reset_pressed() -> void:
	for pot in pots.get_children():
		pot.reset()
