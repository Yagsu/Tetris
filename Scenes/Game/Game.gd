extends CanvasLayer

onready var RetmisGrid		: Node2D			= $GameGridBackground/RetmisGrid

onready var PauseMenu		: Popup 			= $Overlay/PauseMenu
onready var PauseMusicTween : Tween 			= $PauseMusicTween
onready var BlurEnvironment : Environment 		= $Overlay/Blur.environment
onready var MusicPlayer		: AudioStreamPlayer	= $MusicPlayer
onready var NextPieceSprite	: AnimatedSprite	= $RightSideContainer/NextPiece
onready var NextPieceRollTimer					= $RightSideContainer/NextPieceRollTimer

onready var ScoreText		: Label				= $LeftSideContainer/Score
onready var ScoreTween		: Tween				= $LeftSideContainer/ScoreTween

onready var PopupTween		: Tween				= $OpenPopupTween
onready var GameWinScene						= $Overlay/GameWin
onready var GameLoseScene						= $Overlay/GameLose

var RNG					= RandomNumberGenerator.new()
var	PauseState:	bool	= false
var NextPiece:	int		= 0

var LastSpriteUpdate = 0
var SpriteRollInterval = 0.05

func _ready()								-> void:
	Game_Reset()

	RetmisGrid.connect("ScoreChanged", self, "Game_OnScoreUpdated")
	RetmisGrid.connect("GameFinished", self, "Game_OnGameFinished")
	RetmisGrid.connect("QueueNextPiece", self, "Game_OnQueueNextPiece")	
	
	NextPieceRollTimer.connect("timeout", self, "Game_OnRollTimerTimeout")
	
	PauseMenu.connect("PauseToMenuButton", self, "Game_OnPauseToMenu")
	PauseMenu.connect("PauseContinueButton", self, "Game_OnPauseContinueButton")
	
	GameWinScene.connect("WinToMenu", self, "Game_OnPauseToMenu")
	GameWinScene.connect("WinNewGame", self, "Game_OnNewGame")
	
	GameLoseScene.connect("LoseToMenu", self, "Game_OnPauseToMenu")
	GameLoseScene.connect("LoseNewGame", self, "Game_OnNewGame")


func _process(Delta)						-> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if PlayerInfo.GameFinished:
			Game_Unpause()
			get_tree().change_scene("res://Scenes/UI/MainMenu/MainMenu.tscn")
			return

		if PauseState:
			PauseMenu.hide()
			Game_Unpause()
		else:
			PauseMenu.popup_centered()
			Game_Pause()
	
	if NextPieceRollTimer.time_left > 0 and LastSpriteUpdate > SpriteRollInterval:
		var RandomFrame = RNG.randi_range(0, 6)
		
		NextPieceSprite.frame = RandomFrame
		LastSpriteUpdate = 0
	else:
		LastSpriteUpdate += Delta


func Game_Reset()							-> void:
	Grid.Grid_Reset()
	RetmisGrid.Retmis_Reset()
	Game_OnScoreUpdated()


func Game_Pause()							-> void:
	PauseState = true
	get_tree().paused = true

	PauseMusicTween.stop_all()
	PauseMusicTween.BeginTween(MusicPlayer, MusicPlayer.volume_db, -20)
	BlurEnvironment.dof_blur_near_enabled = true

func Game_Unpause()							-> void:
	PauseState = false
	get_tree().paused = false
	
	PauseMusicTween.stop_all()
	PauseMusicTween.BeginTween(MusicPlayer, MusicPlayer.volume_db, -5)
	BlurEnvironment.dof_blur_near_enabled = false
	
	RetmisGrid.Retmis_ResetDropTimer()


func Game_OnScoreUpdated()					-> void:
	ScoreText.set_text("%d" % PlayerInfo.CurrentScore)
	ScoreTween.BeginTween(ScoreText)

func Game_OnGameFinished(PlayerWon: bool)	-> void:
	var PreviousHighscore = ScoreManager.ScoreManager_GetScoreForUser(PlayerInfo.PlayerName)
	var GameEndScene = GameWinScene if PlayerWon else GameLoseScene
	
	ScoreManager.ScoreManager_AddNewScore(PlayerInfo.PlayerName, PlayerInfo.CurrentScore)

	if PlayerInfo.CurrentScore > PreviousHighscore:
		GameEndScene.HighScoreLabel.visible = true
	else:
		GameEndScene.HighScoreLabel.visible = false

	GameEndScene.EndScoreLabel.text = "You scored: %d!" % PlayerInfo.CurrentScore

	Game_Pause()
	PopupTween.BeginTween(GameEndScene)

func Game_OnQueueNextPiece(Piece: int)	-> void:
	NextPiece = Piece
	NextPieceRollTimer.start()

func Game_OnRollTimerTimeout()			-> void:
	NextPieceSprite.frame = NextPiece

func Game_OnPauseContinueButton()				-> void:
	PauseMenu.hide()
	Game_Unpause()

func Game_OnPauseToMenu()						-> void:
	Game_Unpause()
	get_tree().change_scene("res://Scenes/UI/MainMenu/MainMenu.tscn")

func Game_OnNewGame()							-> void:
	GameWinScene.hide()
	GameLoseScene.hide()

	Game_Reset()
	Game_Unpause()
