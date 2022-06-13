extends Node2D

onready var ActivePiece = ($GridRenderer/ActivePiece)
onready var ActivePieceData = ActivePiece.ActivePieceData

onready var TestPiece = $Piece_S
onready var TestPiece2 = $Piece_L

var RNG = RandomNumberGenerator.new()

func _ready():
	ActivePiece.connect("ShouldLockPiece", self, "Game_OnShouldLockPiece")
	ActivePiece.ActivePiece_SetActivePiece(TestPiece)
	RNG.randomize()


#Lineclear, randomizer, wallkick, controls, menu, score


func Game_OnShouldLockPiece():
	Grid.Grid_AddShape(ActivePieceData.Pos, ActivePieceData.ShapeMatrixWidth, ActivePieceData.ShapeMatrixHeight, ActivePieceData.ShapeMatrix)

	var Num = RNG.randf_range(0, 1)

	ActivePiece.ActivePiece_SetActivePiece(TestPiece)

	if Num < 0.5:
		ActivePiece.ActivePiece_SetActivePiece(TestPiece2)



func _on_Timer_timeout():
	ActivePiece.ActivePiece_MoveDown()
