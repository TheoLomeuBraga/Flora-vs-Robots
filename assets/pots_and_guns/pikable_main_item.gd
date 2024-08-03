extends Node3D



func _ready():
	pass 

enum wepon_enum {
	whater_can = 0,
	pistol = 1,
	smg = 2,
	shotgum = 3,
	health = 4
}

@export var item_selected : wepon_enum = wepon_enum.whater_can
@export var to_unlock_item : int = 0

func is_pikable_item():
	pass

func _process(delta):
	pass
