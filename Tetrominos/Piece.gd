extends Node2D

var ShapeMatrixWidth:	int
var ShapeMatrixHeight:	int
var ShapeMatrix:		Array
var PieceColor:			Color
var PieceType			:= -1


func GetShapeMatrix() -> Array:
	return self.ShapeMatrix


func SetAsCurrentPiece(CurrentActivePiece) -> void:
	pass
