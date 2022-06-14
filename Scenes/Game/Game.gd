extends Node2D

onready var ActivePiece		= $Grid/GridRenderer/ActivePiece
onready var ActivePieceData = ActivePiece.ActivePieceData
onready var PieceRandomizer = $Pieces/PieceRandomizer

onready var Pieces = [$Pieces/Piece_I, $Pieces/Piece_J, $Pieces/Piece_L, $Pieces/Piece_O, $Pieces/Piece_S, $Pieces/Piece_T, $Pieces/Piece_Z]

var	PlayerScore: int	= 0
var ScoreTable:	 Array	= [0, 100, 300, 500, 800]

func _ready():
	var	StartPiece: int	= PieceRandomizer.PieceRandomizer_GetNextPiece()

	ActivePiece.connect("ShouldLockPiece", self, "Game_OnShouldLockPiece")
	ActivePiece.connect("ShouldEndGame", self, "Game_OnGameOver")
	ActivePiece.connect("PieceHardDrop", self, "Game_OnPieceHardDrop")
	ActivePiece.connect("PieceSoftDrop", self, "Game_OnPieceSoftDrop")
	Grid.connect("RowsCleared", self, "Game_OnRowsCleared")

	ActivePiece.ActivePiece_SetActivePiece(Pieces[StartPiece])


#menu

func Game_IncreaseScore(Amount):
	assert(not Amount < 0)

	PlayerScore += Amount

	if PlayerScore >= Constants.MAX_SCORE:
		#Player wins
		print("Player wins!")
		get_tree().quit()


func Game_OnShouldLockPiece():
	var	NewPiece:	int

	Grid.Grid_AddShape(ActivePieceData.Pos, ActivePieceData.ShapeMatrixWidth, ActivePieceData.ShapeMatrixHeight, ActivePieceData.ShapeMatrix)

	NewPiece = PieceRandomizer.PieceRandomizer_GetNextPiece()
	ActivePiece.ActivePiece_SetActivePiece(Pieces[NewPiece])
	ActivePiece.ActivePiece_HideSprites()

func Game_OnPieceHardDrop(CellCount):
	Game_IncreaseScore(CellCount * 2)

func Game_OnPieceSoftDrop():
	Game_IncreaseScore(1)

func Game_OnRowsCleared(Count):
	Game_IncreaseScore(ScoreTable[Count])

func Game_OnGameOver():
	print("Final score [%d]" % PlayerScore)

	get_tree().quit()
