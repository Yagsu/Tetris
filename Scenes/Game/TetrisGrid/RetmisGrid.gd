extends Node2D

signal	ScoreChanged(CurrentScore)
signal	GameFinished(PlayerWon)

onready var ActivePiece		= $Grid/GridRenderer/ActivePiece
onready var ActivePieceData = ActivePiece.ActivePieceData
onready var GridRenderer	= $Grid/GridRenderer
onready var PieceRandomizer = $Pieces/PieceRandomizer
onready var DropTimer		= $Grid/GridRenderer/ActivePiece/DropTimer

onready var Pieces = [$Pieces/Piece_I, $Pieces/Piece_J, $Pieces/Piece_L, $Pieces/Piece_O, $Pieces/Piece_S, $Pieces/Piece_T, $Pieces/Piece_Z]

var ScoreTable:	 Array	= [0, 100, 300, 500, 800]

func _ready()								-> void:
	var	StartPiece: int	= PieceRandomizer.PieceRandomizer_GetNextPiece()

	ActivePiece.connect("ShouldLockPiece", self, "Retmis_OnShouldLockPiece")
	ActivePiece.connect("ShouldEndGame", self, "Retmis_OnGameOver")
	ActivePiece.connect("PieceHardDrop", self, "Retmis_OnPieceHardDrop")
	ActivePiece.connect("PieceSoftDrop", self, "Retmis_OnPieceSoftDrop")
	Grid.connect("RowsCleared", self, "Retmis_OnRowsCleared")

	ActivePiece.ActivePiece_SetActivePiece(Pieces[StartPiece])


func Retmis_Reset()							-> void:
	GridRenderer.GridRenderer_Reset()
	ActivePiece.ActivePiece_Reset()

	PlayerInfo.CurrentScore = 0
	PlayerInfo.GameFinished = false

func Retmis_ResetDropTimer()				-> void:
	if ActivePiece.SoftDropActive:
		ActivePiece.ActivePiece_ToggleSoftDrop()

func Retmis_IncreaseScore(Amount)			-> void:
	assert(not Amount < 0)

	if PlayerInfo.GameFinished:
		return

	PlayerInfo.CurrentScore += Amount

	if PlayerInfo.CurrentScore >= Constants.MAX_SCORE:
		PlayerInfo.GameFinished = true
		emit_signal("GameFinished", true)
	
	emit_signal("ScoreChanged")


func Retmis_OnShouldLockPiece()				-> void:
	var	NewPiece:	int

	Grid.Grid_AddShape(ActivePieceData.Pos, ActivePieceData.ShapeMatrixWidth, ActivePieceData.ShapeMatrixHeight, ActivePieceData.ShapeMatrix)

	NewPiece = PieceRandomizer.PieceRandomizer_GetNextPiece()
	ActivePiece.ActivePiece_SetActivePiece(Pieces[NewPiece])
	ActivePiece.ActivePiece_HideSprites()

func Retmis_OnPieceHardDrop(CellCount)		-> void:
	Retmis_IncreaseScore(CellCount * 2)

func Retmis_OnPieceSoftDrop()				-> void:
	Retmis_IncreaseScore(1)

func Retmis_OnRowsCleared(Count):
	Retmis_IncreaseScore(ScoreTable[Count])

func Retmis_OnGameOver()					-> void:
	emit_signal("GameFinished", false)
