extends Popup

signal WinNewGame
signal WinToMenu

onready var	HighScoreLabel: Label = $MarginContainer/VBoxContainer/VBoxContainer/HighScoreLabel
onready var	EndScoreLabel: Label = $MarginContainer/VBoxContainer/VBoxContainer/EndScoreLabel

var TotalTime: float = 0.0

func _process(Delta)				-> void:
	TotalTime += Delta
	
	var Scale = 0.7 + sin(TotalTime * 3) * 0.05

	HighScoreLabel.rect_scale.x = Scale
	HighScoreLabel.rect_scale.y = Scale


func _on_NewGameButton_pressed()	-> void:
	emit_signal("WinNewGame")


func _on_ToMenuButton_pressed()		-> void:
	emit_signal("WinToMenu")
