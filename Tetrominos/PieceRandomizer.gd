extends Node2D

var Bag:			Array = [0, 1, 2, 3, 4, 5, 6]
var PieceSequence:	Array = [0, 1, 2, 3, 4, 5, 6]
var BagSize:		 int = 7
var CurrentBag:		 int = 0
var	NextPieceIndex:	 int = 0


func _ready():
	randomize()
	Bag.shuffle()
	PieceRandomizer_UpdatePieceSequence()


func PieceRandomizer_UpdatePieceSequence()	-> void:
	for i in range(BagSize):
		PieceSequence[i] = Bag[i]

	Bag.shuffle()

func PieceRandomizer_GetNextPiece()			-> int:
	var Piece = PieceSequence[NextPieceIndex]

	NextPieceIndex += 1

	if NextPieceIndex == 7:
		NextPieceIndex = 0
		PieceRandomizer_UpdatePieceSequence()

	return Piece

func PieceRandomizer_PeekNextPiece()		-> int:
	var NextPiece = PieceSequence[NextPieceIndex]
	
	return NextPiece
