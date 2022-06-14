extends Node2D

onready var ActivePiece		= $GridRenderer/ActivePiece
onready var ActivePieceData = ActivePiece.ActivePieceData
onready var PieceRandomizer = $PieceRandomizer

onready var Pieces = [$Piece_I, $Piece_J, $Piece_L, $Piece_O, $Piece_S, $Piece_T, $Piece_Z]

var	PlayerScore: int	= 0
var ScoreTable:	 Array	= [0, 100, 300, 500, 800]

func _ready():
	var	StartPiece: int	= PieceRandomizer.PieceRandomizer_GetNextPiece()

	ActivePiece.connect("ShouldLockPiece", self, "Game_OnShouldLockPiece")
	ActivePiece.connect("ShouldEndGame", self, "Game_OnGameOver")
	ActivePiece.connect("PieceHardDrop", self, "Game_OnPieceHardDrop")
	Grid.connect("RowsCleared", self, "Game_OnRowsCleared")

	ActivePiece.ActivePiece_SetActivePiece(Pieces[StartPiece])


#controls, menu


func Game_OnShouldLockPiece():
	var	NewPiece:	int

	Grid.Grid_AddShape(ActivePieceData.Pos, ActivePieceData.ShapeMatrixWidth, ActivePieceData.ShapeMatrixHeight, ActivePieceData.ShapeMatrix)

	NewPiece = PieceRandomizer.PieceRandomizer_GetNextPiece()
	ActivePiece.ActivePiece_SetActivePiece(Pieces[NewPiece])

func Game_OnPieceHardDrop(CellCount):
	PlayerScore += CellCount * 2

func Game_OnRowsCleared(Count):
	PlayerScore += ScoreTable[Count]

func Game_OnGameOver():
	print("Final score [%d]" % PlayerScore)
	get_tree().quit()


func _on_Timer_timeout():
	ActivePiece.ActivePiece_MoveDown()
