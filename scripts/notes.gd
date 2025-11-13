extends Control

@onready var notes: ItemList = $VBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/ItemList
@onready var note_text: TextEdit = $VBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Edit
var notes_arr: Array[Dictionary]

var is_notes: bool = true

func _ready() -> void:
	# Clear all item list items
	notes.clear()
	# Iterate through experiments for each item
	var dir = DirAccess.open("user://experiments/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				var json = JSON.parse_string(FileAccess.get_file_as_string("user://experiments/" + file_name))
				if json:
					notes.add_item(json["identifier"])
					notes_arr.push_back(json)
				else:
					print("Invalid JSON!")
			file_name = dir.get_next()
	else:
		print("No experiments currently running!")

func save_items():
	for item in notes_arr:
		var j = JSON.new()
		j.data = item
		Save.save_current_experiment(j)

func _on_item_list_item_selected(index: int) -> void:
	# Get selected
	pass
