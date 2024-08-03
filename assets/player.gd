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

func make_gun_stuf():
	if wepon_selected == 0:
		get_node(gunModelPath).mesh = whater_can
	elif wepon_selected == 1:
		get_node(gunModelPath).mesh = pistol
	elif wepon_selected == 2:
		get_node(gunModelPath).mesh = smg
	elif wepon_selected == 3:
		get_node(gunModelPath).mesh = shotgum

func _physics_process(delta):
	move(delta)
	look_around(delta)
	make_gun_stuf()
	
