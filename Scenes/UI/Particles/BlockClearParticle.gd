extends Particles2D

func _ready() -> void:
	yield(get_tree().create_timer(0.5), "timeout")
	queue_free()
