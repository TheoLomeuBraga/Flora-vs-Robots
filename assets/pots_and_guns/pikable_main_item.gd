extends Node3D

@export var plant : NodePath
@export var display : NodePath

var plant_node : Node3D
var display_node : Node3D

var player : Node3D


func _ready():
	plant_node = get_node(plant)
	display_node = get_node(display)
	player = get_tree().get_root().get_node("GameSceane/Player")

enum wepon_enum {
	whater_can = 0,
	pistol = 1,
	smg = 2,
	shotgum = 3,
	health = 4,
	fertilizer = 5,
}

@export var item_selected : wepon_enum = wepon_enum.whater_can
@export var to_unlock_item : int = 0

@export var bloked = false

func is_pikable_item():
	pass

var block_this_frame := false
func add_fertilizer():
	block_this_frame = true
	to_unlock_item += 1 

func _process(delta):
	
	if not block_this_frame:
	
		if plant_node != null:
			plant_node.visible  = to_unlock_item == 0
	
		if display_node != null:
			display_node.text = str(-to_unlock_item)
			if to_unlock_item == 0:
				display_node.text = "V"
		
	block_this_frame = false
	
	
	if item_selected == 5 and player.global_position.distance_to(global_position) < 2:
		player.fertilizer_count += 1
		queue_free()
