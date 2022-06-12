extends "res://Tetrominos/Piece.gd"

func _ready():
	self.ShapeMatrixWidth = 4
	self.ShapeMatrixHeight = 3
	self.ShapeMatrix = [[0, 0, 0], [4, 4, 0], [4, 4, 0], [0, 0, 0]]
	self.PieceType = 4