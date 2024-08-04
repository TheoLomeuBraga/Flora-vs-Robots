extends CharacterBody3D




var player : Node3D
@export var explosion : PackedScene

func _ready():
	player = get_tree().get_root().get_node("GameSceane/Player")

@export var speed := 500.0
@export var health := 1
func comfirm_enemy():
	pass

func _physics_process(delta):
	var direction : Vector3 = (player.global_position - global_position).normalized()
	
	velocity = direction * speed * delta
	move_and_slide()
	
	if health <= 0:
		var ex : Node3D = explosion.instantiate()
		get_tree().get_root().add_child(ex)
		ex.global_position = global_position
		queue_free()
		
	
	if global_position.distance_to(player.global_position) < 1.1:
		player.damage()
