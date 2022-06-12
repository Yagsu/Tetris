extends "res://Tetrominos/Piece.gd"

func _ready():
	self.ShapeMatrixWidth = 3
	self.ShapeMatrixHeight = 3
	self.ShapeMatrix = [[0, 6, 0], [6, 6, 0], [0, 6, 0]]
	self.PieceType = 6