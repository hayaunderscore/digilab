extends Node

# Json information that contains the current save being modified
# TODO allow multiple experiments to run at once
var save: JSON

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
