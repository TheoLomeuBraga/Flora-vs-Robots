extends Node3D

@export var wave_intensity : int = 0

@export var enemy_asset : PackedScene

var camera : Camera3D
var player : Node3D

func _ready():
	camera = get_tree().get_root().get_node("GameSceane/Player/Camera3D")
	player = get_tree().get_root().get_node("GameSceane/Player")
	$"tutorials/tutorial 1".visible = true
	$"tutorials/tutorial 2".visible = false
	$"tutorials/tutorial 3".visible = false
	$"tutorials/tutorial 4".visible = false
	$"tutorials/tutorial 5".visible = false

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

var tutorial_step := 0
func _process(delta):
	
	if Global.wave_no > 0:
		$wave_no.visible = wave_duration > 0
		$wave_no.text = "wave: " + str(Global.wave_no)
		
		if wave_duration > 0 and Global.wave_no > 0:
			wave_is_over = false
			if time_to_next_spawn <= 0:
				time_to_next_spawn = 1.0 / float(wave_intensity)
				spawn_enemy()
	
		wave_duration -= delta
		time_to_next_spawn -= delta
	
	
		if wave_duration <= 0 and $enemys.get_child_count() == 0 and wave_is_over == false:
			$wave_no.visible = true
			Global.wave_no += 1
			wave_is_over = true
			player.fertilizer_count += 1
		
		if wave_is_over and player.fertilizer_count == 0:
			wave_duration = 10 + (Global.wave_no * 2)
			wave_intensity = 2 + Global.wave_no
			$waveStart.play()
	else:
			
		if tutorial_step == 0:
			if $Player.wepon_selected == 0:
				
				$"tutorials/tutorial 1".visible = false
				$"tutorials/tutorial 2".visible = true
				tutorial_step += 1
				
		elif tutorial_step == 1:
			if $RedPot.to_unlock_item == 0:
				$"tutorials/tutorial 2".visible = false
				$"tutorials/tutorial 3".visible = true
				$OrangePot.bloked = false
				$PinkPot.bloked = false
				tutorial_step += 1
				
		elif tutorial_step == 2:
			if $Player.get_node("healthBar").value == 10:
				print("A")
				$"tutorials/tutorial 3".visible = false
				$"tutorials/tutorial 4".visible = true
				tutorial_step += 1
				
		elif tutorial_step == 3:
			if $Player.wepon_selected == 1:
				$"tutorials/tutorial 3".visible = false
				$"tutorials/tutorial 4".visible = true
				tutorial_step += 1
		else:
			$"tutorials/tutorial 4".visible = false
			Global.wave_no = 1
			$waveStart.play()
	
	$"tutorials/tutorial 5".visible = Global.wave_no == 2 and wave_is_over
		
	
