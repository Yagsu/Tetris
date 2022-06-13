extends "res://Tetrominos/Piece.gd"

func _ready():
	self.ShapeMatrixWidth	= 3
	self.ShapeMatrixHeight	= 3
	self.ShapeMatrix = [[7, 0, 0], [7, 7, 0], [0, 7, 0]]
	self.PieceType = 7