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
	shotgum = 3
}

@export var wepon_selected : wepon_enum



func look_around(delta):
	var mouse_pos : Vector2 = $Camera3D.get_viewport().get_mouse_position()
	var target_pos : Vector3 = $Camera3D.project_local_ray_normal(mouse_pos)
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


func make_gun_stuf(delta):
	
	if wepon_selected == 0:
			
		get_node(gunModelPath).mesh = whater_can
			
	elif wepon_selected == 1:
		
		get_node(gunModelPath).mesh = pistol
		if Input.is_action_just_pressed("shot"):
			var b = bullet.instantiate()
			get_tree().get_root().add_child(b)
			b.global_position = $player_model/muzle.global_position
			b.rotation = $player_model/muzle.global_rotation
			b.set_color(Color.GREEN)
			
		
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
	
	time_to_next_shot -= delta

func _physics_process(delta):
	move(delta)
	look_around(delta)
	make_gun_stuf(delta)
	
	print("cc",$player_model/item.get_collision_count())
	if $player_model/item.is_colliding():
		var i : int = 0
		while i < $player_model/item.get_collision_count():
			var item_coliding = $player_model/item.get_collider(i)
			print(item_coliding.has_meta("item_selected") , item_coliding.has_meta("to_unlock_item"))
			if item_coliding.has_meta("item_selected") and item_coliding.has_meta("to_unlock_item"):
				#is coliding colectable item
				if Input.is_action_just_pressed("ui_accept") and item_coliding.to_unlock_item == 0:
					wepon_selected = item_coliding.item_selected
			
			i+=1

	
