extends Control

onready var MainMenuBanner 		= $TextureRect
onready var MusicPlayer 		= $MusicPlayer
onready var NewGameMenu 		= $NewGameMenu
onready var ScoreboardMenu 		= $ScoreboardMenu
onready var SettingsMenu 		= $SettingsMenu
onready var OpenPopupTween		= $OpenPopupTween
onready var MusicVolumeTween	= $MusicVolumeTween

var TotalTime: float = 0.0

func _ready()							-> void:
	$VBoxContainer/StartButton.grab_focus();

	MusicPlayer.volume_db = -80.0
	MusicVolumeTween.BeginTween(MusicPlayer)
	MusicPlayer.play()

func _process(Delta)					-> void:
	TotalTime += Delta

	var Scale = 0.7 + sin(TotalTime * 3) * 0.05

	MainMenuBanner.rect_scale.x = Scale
	MainMenuBanner.rect_scale.y = Scale


func _on_StartButton_pressed()			-> void:
	OpenPopupTween.BeginTween(NewGameMenu)


func _on_ScoreboardButton_pressed()		-> void:
	OpenPopupTween.BeginTween(ScoreboardMenu)


func _on_SettingsButton_pressed()		-> void:
	OpenPopupTween.BeginTween(SettingsMenu)


func _on_QuitButton_pressed()			-> void:
	get_tree().quit()


func _on_AudioStreamPlayer_finished()	-> void:
	MusicPlayer.play()

