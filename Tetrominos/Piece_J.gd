extends "res://Tetrominos/Piece.gd"

func _ready():
	self.ShapeMatrixWidth = 3
	self.ShapeMatrixHeight = 3
	self.ShapeMatrix = [[2, 2, 0], [0, 2, 0], [0, 2, 0]]
	self.PieceType = 2