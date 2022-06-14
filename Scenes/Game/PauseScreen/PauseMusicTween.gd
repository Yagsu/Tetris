extends Tween

func BeginTween(MusicPlayer : AudioStreamPlayer, from : float, to : float) -> void:
	interpolate_property(
		MusicPlayer,
		"volume_db",
		from,
		to,
		0.5,
		Tween.TRANS_LINEAR
	)
	start()
