extends Node

# Database abstraction to save data about various "experiments"

# Json information that contains the current save being modified
# TODO allow multiple experiments to run at once
var save: JSON

# Save database
# Holds information about experiments
# And notes
# And various other stuff
var save_db: SQLite
var save_db_path: String = "user://experiments.db"

# Schema
var save_schema: Dictionary = {
	"id": {"data_type": "int", "primary_key": true, "not_null": true, "auto_increment": true},
	"type": {"data_type": "int", "default": EXPERIMENT_TYPES.BIOLOGY},
	"name": {"data_type": "text"},
	"notes": {"data_type": "text"},
	"active": {"data_type": "int", "default": 0},
	"event_data": {"data_type": "blob"}
}

enum EXPERIMENT_TYPES {
	BIOLOGY,
	CHEMISTRY,
	PHYSICS
}

func _ready() -> void:
	save_db = SQLite.new()
	save_db.path = save_db_path
	save_db.open_db()
	# Query whether the tables exist or not
	# This is an array just in case we add more tables in the future!
	for table in ["experiments"]:
		save_db.query_with_bindings("SELECT name FROM sqlite_master WHERE type='table' AND name=?;", [table])
		if save_db.query_result.is_empty():
			save_db.create_table(table, save_schema)
	save_db.close_db()

func _exit_tree() -> void:
	save_db.close_db()

func set_experiment_active(name: String, type: EXPERIMENT_TYPES):
	save_db.open_db()
	save_db.path = save_db_path
	# Check if it exists before we insert a row
	save_db.query_with_bindings("SELECT * FROM experiments WHERE name=?", [name])
	if save_db.query_result.is_empty():
		save_db.insert_row("experiments", {
			"type": type,
			"name": name,
			"active": 1
		})
	else:
		save_db.update_rows("experiments", "name = '%s'" % [name], {
			"type": type,
			"active": 1
		})
	save_db.close_db()

func set_experiment_inactive(name):
	save_db.open_db()
	save_db.path = save_db_path
	# It needs to exist, dingus!
	save_db.query_with_bindings("SELECT 1 FROM experiments WHERE name=?", [name])
	if save_db.query_result.is_empty(): return
	save_db.update_rows("experiments", "name = '%s'" % [name], {
		"active": 0
	})
	save_db.close_db()

func get_active_experiments() -> Array[Dictionary]:
	save_db.open_db()
	save_db.path = save_db_path
	save_db.query("SELECT * FROM experiments WHERE active=1")
	if save_db.query_result.is_empty(): save_db.close_db(); return []
	var ret = save_db.query_result.duplicate(true)
	save_db.close_db()
	return ret

func set_experiment_note(name: String, note: String):
	save_db.open_db()
	save_db.path = save_db_path
	# It needs to exist, dingus!
	save_db.query_with_bindings("SELECT 1 FROM experiments WHERE name=?", [name])
	if save_db.query_result.is_empty(): save_db.close_db(); return
	save_db.update_rows("experiments", "name = '%s'" % [name], {
		"notes": note
	})
	save_db.close_db()
	
# For multi change
func set_experiments_note(dict: Array[Dictionary]):
	save_db.open_db()
	save_db.path = save_db_path
	for val in dict:
		# It needs to exist, dingus!
		save_db.query_with_bindings("SELECT 1 FROM experiments WHERE name=?", [val["name"]])
		if save_db.query_result.is_empty(): continue
		save_db.update_rows("experiments", "name = '%s'" % [val["name"]], {
			"notes": val["note"]
		})
	save_db.close_db()

func get_experiment_note(name: String):
	save_db.open_db()
	save_db.path = save_db_path
	# It needs to exist, dingus!
	save_db.query_with_bindings("SELECT * FROM experiments WHERE name=?", [name])
	if save_db.query_result.is_empty(): save_db.close_db(); return ""
	var ret = save_db.query_result.duplicate(true)
	print(ret)
	save_db.close_db()
	return ret[0]["notes"]

func start_experiment_saving(path: String, identifier: String, resume: bool = false):
	save = JSON.new()
	if FileAccess.file_exists(path):
		if not resume:
			DirAccess.remove_absolute(path)
		else:
			save.parse(FileAccess.get_file_as_string(path))
	if not FileAccess.file_exists(path):
		save.data = {}
	save.data["identifier"] = identifier
	save.data["path"] = path

func save_current_experiment(s: JSON = null):
	if not s: 
		s = save
	if s:
		if not DirAccess.dir_exists_absolute("user://experiments/"):
			DirAccess.make_dir_recursive_absolute("user://experiments/")
		var f = FileAccess.open(save.data["path"], FileAccess.WRITE)
		print(FileAccess.get_open_error())
		if f:
			f.store_string(JSON.stringify(save.data))
			f.close()
	save = null
