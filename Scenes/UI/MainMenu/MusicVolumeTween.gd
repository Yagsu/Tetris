extends Tween

func BeginTween(Stream: AudioStreamPlayer) -> void:
	interpolate_property(
		Stream,
		"volume_db",
		-80.0,
		0.0,
		0.5,
		Tween.TRANS_LINEAR
	)
	start()
