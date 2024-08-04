extends Node3D

@export var wave_intensity : int = 0

@export var enemy_asset : PackedScene

var camera : Camera3D
var player : Node3D

func _ready():
	camera = get_tree().get_root().get_node("GameSceane/Player/Camera3D")
	player = get_tree().get_root().get_node("GameSceane/Player")

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
			$enemys.add_child(enemy)
			enemy.global_position = spawn.global_position
			break
		
		tries -= 1

@export var wave_duration : float = 10.0
var time_to_next_spawn : float = 1.0

var wave_is_over := false
func _process(delta):
	if wave_duration > 0:
		wave_is_over = false
		if time_to_next_spawn <= 0:
			time_to_next_spawn = 1.0 / float(wave_intensity)
			spawn_enemy()
	
	wave_duration -= delta
	time_to_next_spawn -= delta
	
	
	if wave_duration <= 0 and $enemys.get_child_count() == 0 and wave_is_over == false:
		wave_is_over = true
		print("wave is over")
		player.fertilizer_count += 1
		
	if wave_is_over and player.fertilizer_count == 0:
		wave_duration = 10
		wave_intensity = 2
		$waveStart.play()
