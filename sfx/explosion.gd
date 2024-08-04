extends GPUParticles3D


var rng = RandomNumberGenerator.new()

func _ready():
	$AudioStreamPlayer.pitch_scale = rng.randf_range(0.5, 2.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $AudioStreamPlayer.playing == false:
		queue_free()
