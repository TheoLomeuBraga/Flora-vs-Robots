extends CharacterBody3D




var player : Node3D

func _ready():
	player = get_tree().get_root().get_node("GameSceane/Player")
	print(player)

@export var speed := 500.0
@export var health := 1
func comfirm_enemy():
	pass

func _physics_process(delta):
	var direction : Vector3 = (player.global_position - global_position).normalized()
	
	velocity = direction * speed * delta
	move_and_slide()
	
	if health <= 0:
		queue_free()
