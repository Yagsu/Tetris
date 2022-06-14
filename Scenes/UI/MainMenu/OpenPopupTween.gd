extends Tween

func BeginTween(Pop: Popup)		-> void:
	Pop.popup_centered()
	interpolate_property(
		Pop, 
		"rect_scale:x",
		0.0,
		1.0,
		0.25,
		Tween.TRANS_CUBIC
		)
	start()
