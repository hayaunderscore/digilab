extends Button
class_name SceneButton

@export var scene: PackedScene
@export var back_button: bool = false

var clicked: bool = false

func _pressed() -> void:
	if clicked: return
	# Goes to a scene
	if scene:
		MenuHelper.back_scenes.push_back(get_tree().current_scene.scene_file_path)
		get_tree().change_scene_to_packed(scene)
		MenuHelper.current_scene_nest += 1
	# Goes to the last/previous scene
	if back_button and MenuHelper.back_scenes.get(MenuHelper.current_scene_nest - 1) != null:
		print("go bacc")
		get_tree().change_scene_to_file(MenuHelper.back_scenes[MenuHelper.current_scene_nest - 1])
		MenuHelper.back_scenes.pop_back()
		MenuHelper.current_scene_nest -= 1
	# Wtf! Not set? Explode!
	if scene == null and not back_button:
		SoundManager.play_sfx("res://assets/snd/snd_badexplosion.wav")
		modulate.a = 0
	clicked = true
