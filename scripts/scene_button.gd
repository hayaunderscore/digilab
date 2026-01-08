extends Button
class_name SceneButton

@export var scene: PackedScene
@export var back_button: bool = false

var clicked: bool = false

signal changed_scene

func _pressed() -> void:
	if clicked: return
	# Goes to a scene
	if scene:
		MenuHelper.back_scenes.push_back(get_tree().current_scene.scene_file_path)
		get_tree().change_scene_to_packed(scene)
		changed_scene.emit()
		MenuHelper.current_scene_nest += 1
	# Goes to the last/previous scene
	if back_button and MenuHelper.back_scenes.get(MenuHelper.current_scene_nest - 1) != null:
		get_tree().change_scene_to_file(MenuHelper.back_scenes[MenuHelper.current_scene_nest - 1])
		MenuHelper.back_scenes.pop_back()
		MenuHelper.current_scene_nest -= 1
		changed_scene.emit()
	# Wtf! Not set? Explode!
	if scene == null and not back_button:
		SoundManager.play_sfx("res://assets/snd/snd_badexplosion.wav")
		modulate.a = 0
	clicked = true


func _on_infooo_pressed() -> void:
	get_viewport().gui_release_focus()
	$HUD/Overlaaay.visible = true


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://objs/phy_exp_1.tscn")
