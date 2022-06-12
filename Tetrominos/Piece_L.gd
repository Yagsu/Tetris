extends "res://Tetrominos/Piece.gd"

func _ready():
	self.ShapeMatrixWidth = 3
	self.ShapeMatrixHeight = 3
	self.ShapeMatrix = [[0, 3, 0], [0, 3, 0], [3, 3, 0]]
	self.PieceType = 3