extends Node3D

@export var wave_intensity : int = 0

@export var enemy_asset : PackedScene

var camera : Camera3D

func _ready():
	camera = get_tree().get_root().get_node("GameSceane/Player/Camera3D")

func stop_wave():
	wave_intensity = 0
	
func spawn_enemy():
	var spawns = $spawns.get_children()
	var tries = spawns.size()
	
	while tries > 0:
		var index = randi() % spawns.size()
		var spawn = spawns[index]
		
		if !camera.is_position_in_frustum(spawn.global_position):
			var enemy : Node3D = enemy_asset.instantiate()
			enemy.global_position = spawn.global_position
			get_tree().get_root().add_child(enemy)
			break
		
		tries -= 1

var time_to_next_spawn : float = 1.0
func _process(delta):
	if time_to_next_spawn <= 0:
		time_to_next_spawn = 5.0 / float(wave_intensity)
		spawn_enemy()
	
	time_to_next_spawn -= delta
