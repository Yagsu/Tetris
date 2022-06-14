extends Node2D

var ShapeMatrixWidth:	int
var ShapeMatrixHeight:	int
var ShapeMatrix:		Array
var PieceColor:			Color
var PieceType			:= -1
var WallkickDataCCW		:= Constants.JLTSZ_WALLKICK_CCW
var WallkickDataCW		:= Constants.JLTSZ_WALLKICK_CW
var SpawnPos			:= Vector2(3, 0)
