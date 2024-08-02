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

func look_around(delta):
	var mouse_pos : Vector2 = $Camera3D.get_viewport().get_mouse_position()
	var target_pos : Vector3 = $Camera3D.project_local_ray_normal(mouse_pos)
	target_pos.z = target_pos.y
	
	target_pos.y = 0
	target_pos = target_pos.normalized()
	
	
	$player_model.look_at($player_model.global_position + target_pos,Vector3.UP)
	$player_model.rotation.y = -$player_model.rotation.y

func _physics_process(delta):
	move(delta)
	look_around(delta)
	
