extends Control



func _ready():
	$VBoxContainer/main_menu.grab_focus()



func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://menus/main_menu.tscn")
