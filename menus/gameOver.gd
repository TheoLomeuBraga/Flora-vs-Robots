extends Control



func _ready():
	$VBoxContainer/main_menu.grab_focus()
	$VBoxContainer/Label2.text = "you survive until the wave: " + str(Global.wave_no)
	Global.wave_no = 0



func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://menus/main_menu.tscn")
