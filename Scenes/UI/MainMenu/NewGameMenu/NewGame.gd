extends Popup

onready var PlayerNameField = $Panel/MainVBox/MarginContainer/HBoxContainer/PlayerNameField

func _ready()					-> void:
	if not PlayerInfo.PlayerName.empty():
		PlayerNameField.text = PlayerInfo.PlayerName

func _on_PlayButton_pressed()	-> void:
	var PlayerName = PlayerNameField.text
	
	if PlayerName.empty():
		return

	PlayerInfo.PlayerName = PlayerName
	get_tree().change_scene("res://Scenes/Game/Game.tscn")
