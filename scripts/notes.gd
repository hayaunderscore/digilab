extends Control

@onready var notes: ItemList = $VBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/ItemList
@onready var note_text: TextEdit = $VBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Edit
var notes_arr: Array[String]

var is_notes: bool = true
var current_index: int = 0

func _ready() -> void:
	# Clear all item list items
	notes.clear()
	# Get all active experiments from the database
	var experiments = Save.get_active_experiments()
	for experiment in experiments:
		# Loop through them and add them to the items list
		notes.add_item(experiment["name"])
		if experiment["notes"]:
			notes_arr.push_back(experiment["notes"])
		else:
			notes_arr.push_back("")
	if experiments.is_empty():
		# No experiments are found active for the time being...
		note_text.editable = false

func _on_edit_text_changed() -> void:
	# Set this to that
	notes_arr[current_index] = note_text.text

func _on_item_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	# Save current index and set note_text to the note associated with the experiment name
	current_index = index
	note_text.text = notes_arr[current_index]

func _on_back_changed_scene() -> void:
	var arr: Array[Dictionary]
	for i in notes_arr.size():
		var note = notes_arr[i]
		var name = notes.get_item_text(i)
		arr.push_back({
			"name": name,
			"note": note
		})
	Save.set_experiments_note(arr)
