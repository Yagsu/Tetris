extends "res://Tetrominos/Piece.gd"

func _ready():
	self.ShapeMatrixWidth	= 4
	self.ShapeMatrixHeight	= 4
	self.ShapeMatrix = [[0, 1, 0, 0], [0, 1, 0, 0], [0, 1, 0, 0], [0, 1, 0, 0]]
	self.PieceType = 1
	self.WallkickDataCCW	= Constants.I_WALLKICK_CCW
	self.WallkickDataCW		= Constants.I_WALLKICK_CW
