extends Node2D

onready var ActivePiece = ($GridRenderer/ActivePiece)
onready var ActivePieceData = ActivePiece.ActivePieceData

onready var TestPiece = $Piece_I
onready var TestPiece2 = $Piece_L

var RNG = RandomNumberGenerator.new()

func _ready():
	ActivePiece.connect("ShouldLockPiece", self, "Game_OnShouldLockPiece")
	Grid.connect("RowsCleared", self, "Game_OnRowsCleared")

	ActivePiece.ActivePiece_SetActivePiece(TestPiece)
	RNG.randomize()


#randomizer, ghost piece, controls, menu, score


func Game_OnShouldLockPiece():
	Grid.Grid_AddShape(ActivePieceData.Pos, ActivePieceData.ShapeMatrixWidth, ActivePieceData.ShapeMatrixHeight, ActivePieceData.ShapeMatrix)


	#Pop next piece from randomizer

	var Num = RNG.randf_range(0, 1)

	ActivePiece.ActivePiece_SetActivePiece(TestPiece)

	if Num < 0.5:
		ActivePiece.ActivePiece_SetActivePiece(TestPiece2)

func Game_OnRowsCleared(Count):
	print("Rows cleared [%d]" % Count)


func _on_Timer_timeout():
	ActivePiece.ActivePiece_MoveDown()
