extends Popup

signal	PauseToMenuButton
signal	PauseContinueButton


func _ready() -> void:
	$MarginContainer/VBoxContainer/HBoxContainer/ContinueButton.grab_focus()


func _on_ToMenuButton_pressed()			-> void:
	emit_signal("PauseToMenuButton")	

func _on_ContinueButton_pressed()		-> void:
	emit_signal("PauseContinueButton")
