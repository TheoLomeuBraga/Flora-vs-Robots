extends Node3D



func _ready():
	pass


@export var color : Color = Color.WHITE

@export var speed : float = 16

func set_color(color : Color):
	$MeshInstance3D.get_surface_override_material(0).set("albedo_color",color)


func _physics_process(delta):
	
	$RayCast3D.target_position.x = delta * speed
	$RayCast3D.position.x = -(delta * speed)
	
	position += get_global_transform().basis.x * delta * speed
	
	if $RayCast3D.is_colliding():
		queue_free()
		

