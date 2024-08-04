extends Node3D



func _ready():
	pass


@export var color : Color = Color.WHITE

@export var speed : float = 16

func set_color(color : Color):
	$MeshInstance3D.get_surface_override_material(0).set("albedo_color",color)

enum factions {
	plants = 0,
	robot = 1
}

@export var faction : factions  = 0

func _physics_process(delta):
	
	$RayCast3D.target_position.x = delta * speed
	$RayCast3D.position.x = -(delta * speed)
	
	position += get_global_transform().basis.x * delta * speed
	
	if $RayCast3D.is_colliding() and $RayCast3D.get_collider():
		if $RayCast3D.get_collider().has_method("comfirm_enemy") and faction == 0:
			$RayCast3D.get_collider().health -= 1
			
		queue_free()
		

