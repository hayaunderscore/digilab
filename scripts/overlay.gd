extends Control
class_name Overlay

@export_multiline var text: PackedStringArray
var current_index = 1


func _ready() -> void:
	visible = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		visible = true
	if Input.is_action_just_pressed("ui_right"):
		current_index = wrapi(current_index + 1, 0, text.size())
	if Input.is_action_just_pressed("ui_left"):
		current_index = wrapi(current_index - 1, 0, text.size())
	$ColorRect/PanelContainer/HBoxContainer/Label.text = text[current_index]
