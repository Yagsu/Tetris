extends "res://Tetrominos/Piece.gd"

func _ready():
	self.ShapeMatrixWidth	= 3
	self.ShapeMatrixHeight	= 3
	self.ShapeMatrix = [[0, 5, 0], [5, 5, 0], [5, 0, 0]]
	self.PieceType = 5