extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

@export var game_ceane : PackedScene
func _on_start_pressed():
	get_tree().change_scene_to_packed(game_ceane)


func _on_quit_pressed():
	get_tree().quit()


