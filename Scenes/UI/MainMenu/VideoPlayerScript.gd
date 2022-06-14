extends VideoPlayer

func _process(Delta)		-> void:
	if not is_playing():
		play()

func _on_MainMenu_resized()	-> void:
	rect_size = get_viewport_rect().size
