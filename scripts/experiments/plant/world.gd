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

# Save path for experiment info
var save_path = "user://experiments/1.dat"

# This starts the sprouting 
func _on_start_button_pressed() -> void:
	# This goes through every pot in the scene.
	# All pots are contained within a node, for organization.
	for pot in pots.get_children():
		# Start each pot
		Save.set_experiment_active("Experiment 1", Save.EXPERIMENT_TYPES.BIOLOGY)
		pot.start($HUD/Control/Speed.value)

func _on_pause_button_pressed() -> void:
	for pot in pots.get_children():
		pot.pause()

func _on_reset_pressed() -> void:
	for pot in pots.get_children():
		pot.reset()
		# Technically the experiment still exists, just inactive
		Save.set_experiment_inactive("Experiment 1")

func _on_speed_value_changed(value: float) -> void:
	$HUD/Control/Speed/Label2.text = "%d sec." % [value]

func _on_info_pressed() -> void:
	get_viewport().gui_release_focus()
	$HUD/Overlay.visible = true
