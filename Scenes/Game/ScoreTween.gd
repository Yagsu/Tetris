extends Tween

func BeginTween(ScoreLabel: Label) -> void:
	interpolate_property(
		ScoreLabel,
		"rect_scale",
		Vector2(1.5, 1.5),
		Vector2(1, 1),
		0.25,
		Tween.TRANS_BOUNCE
	)
	
	start()

