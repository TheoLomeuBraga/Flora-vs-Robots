extends CharacterBody3D


@export var SPEED :float = 5.0



func move(delta):
	var input_dir = Input.get_vector("ui_up", "ui_down","ui_right","ui_left")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	

enum wepon_enum {
	whater_can = 0,
	pistol = 1,
	smg = 2,
	shotgum = 3,
	health = 4
}

@export var wepon_selected : wepon_enum



func look_around(delta):
	
	
	var mouse_pos : Vector2 = $Camera3D.get_viewport().get_mouse_position()
	var target_pos : Vector3 = $Camera3D.project_local_ray_normal(mouse_pos)
	
	var joystick_look_vector : Vector2 = Input.get_vector("look_left","look_right","look_down","look_up")
	if joystick_look_vector.length() > 0.5:
		target_pos.x = joystick_look_vector.x
		target_pos.y = joystick_look_vector.y
	
	
	target_pos.z = target_pos.y
	
	target_pos.y = 0
	target_pos = target_pos.normalized()
	
	$player_model.look_at($player_model.global_position + target_pos,Vector3.UP)
	$player_model.rotation.y = -$player_model.rotation.y

@export var gunModelPath : NodePath

@export var whater_can : Mesh
@export var pistol : Mesh
@export var smg : Mesh
@export var shotgum : Mesh

var time_to_next_shot = 0.0

@export var bullet : PackedScene
var rng := RandomNumberGenerator.new()

var fertilizer_count := 5

func make_gun_stuf(delta):
	
	if wepon_selected == 0:
			
		get_node(gunModelPath).mesh = whater_can
		
		if $player_model/item.is_colliding():
			var item_coliding = $player_model/item.get_collider().get_parent()
		
			if item_coliding.has_method("is_pikable_item"):
			
				if (Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("shot") ) and item_coliding.to_unlock_item < 0 and fertilizer_count > 0:
					item_coliding.add_fertilizer()
					fertilizer_count -= 1
					$Audio.stream = preload("res://sfx/watering-with-a-watering-can-39121.mp3")
					$Audio.pitch_scale = rng.randf_range(1.25,1.75)
					$Audio.seek(2)
					$Audio.play()
			
	elif wepon_selected == 1:
		
		get_node(gunModelPath).mesh = pistol
		if Input.is_action_just_pressed("shot"):
			var b = bullet.instantiate()
			get_tree().get_root().add_child(b)
			b.global_position = $player_model/muzle.global_position
			b.rotation = $player_model/muzle.global_rotation
			b.set_color(Color.GREEN)
			
			$Audio.stream = preload("res://sfx/bamboo-hit-80186.mp3")
			$Audio.pitch_scale = rng.randf_range(0.75,1.25)
			$Audio.play()
		
	elif wepon_selected == 2:
		
		get_node(gunModelPath).mesh = smg
		if Input.is_action_pressed("shot") and time_to_next_shot <= 0 :
			var b = bullet.instantiate()
			get_tree().get_root().add_child(b)
			b.global_position = $player_model/muzle.global_position
			b.rotation = $player_model/muzle.global_rotation
			b.rotation_degrees.y += rng.randf_range(20.0,-20.0)
			b.set_color(Color.DEEP_PINK)
			time_to_next_shot = 0.1
			
			$Audio.stream = preload("res://sfx/bamboo-hit-80186.mp3")
			$Audio.pitch_scale = rng.randf_range(1.25,1.75)
			$Audio.play()
		
	elif wepon_selected == 3:
		
		get_node(gunModelPath).mesh = shotgum
		if Input.is_action_just_pressed("shot") and time_to_next_shot <= 0 :
			var i : int = 0
			while i < 10:
				i+=1
				var b = bullet.instantiate()
				get_tree().get_root().add_child(b)
				b.global_position = $player_model/muzle.global_position
				b.rotation = $player_model/muzle.global_rotation
				b.rotation_degrees.y += rng.randf_range(45.0,-45.0)
				b.set_color(Color.ORANGE_RED)
				time_to_next_shot = 0.5
			
			$Audio.stream = preload("res://sfx/falling-bamboo-83469.mp3")
			$Audio.pitch_scale = rng.randf_range(1.25,1.75)
			$Audio.play()
	
	time_to_next_shot -= delta

@export var game_over_screen : PackedScene

func comfirm_player():
	pass
	


func _physics_process(delta):
	
	
	move(delta)
	look_around(delta)
	make_gun_stuf(delta)
	
	if $player_model/item.is_colliding():
		var i : int = 0
		var item_coliding = $player_model/item.get_collider()
		if item_coliding != null and item_coliding.get_parent() != null:
			item_coliding = item_coliding.get_parent()
		
		if item_coliding != null:
			print(item_coliding)
		
			if item_coliding.has_method("is_pikable_item"):
			
				if Input.is_action_just_pressed("ui_accept") and item_coliding.to_unlock_item == 0 and item_coliding.block_this_frame == false:
					if item_coliding.item_selected == 4:
						item_coliding.to_unlock_item = -3
						$healthBar.value = 10
					else:
						wepon_selected = item_coliding.item_selected
	
	if $healthBar.value == 0:
		get_tree().change_scene_to_packed(game_over_screen)
		
	$fertilizer.text = "Fertilizer: " + str(fertilizer_count)
	
