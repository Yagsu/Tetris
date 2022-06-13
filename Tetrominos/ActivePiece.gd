extends Node2D

signal ShouldLockPiece

var CollisionResult = Grid.CollisionResult
var ActivePieceData = {
	Type				= -1,
	Pos					= Vector2(0, 0),
	GhostPos			= Vector2(0, 0),
	RotationState		= 0,
	ShapeMatrixWidth	= 4,
	ShapeMatrixHeight	= 4,
	ShapeMatrix			= [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
	CollisionMatrix		= [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
	WallkickDataCW		= null,
	WallkickDataCCW		= null,
}


func _ready():
	pass

func _draw():
	ActivePiece_Draw()

func _process(Delta: float) -> void:
	if Input.is_action_just_pressed("DEBUG_TURN_CW"):
		ActivePiece_RotateCW()
		
	if Input.is_action_just_pressed("DEBUG_TURN_CCW"):
		ActivePiece_RotateCCW()
		
	if Input.is_action_just_pressed("DEBUG_MOVE_DOWN"):
		ActivePiece_MoveDown()

	if Input.is_action_just_pressed("DEBUG_MOVE_LEFT"):
		ActivePiece_MoveLeft()
	
	if Input.is_action_just_pressed("DEBUG_MOVE_RIGHT"):
		ActivePiece_MoveRight()

	if Input.is_action_just_pressed("DEBUG_HARD_DROP"):
		ActivePiece_HardDrop()
	



func ActivePiece_ToScreen(Pos: Vector2) -> Vector2:
	return Pos * Grid.GRID_CELLSIZE

func ActivePiece_Draw()					-> void:
	var ShapeMatrix: Array	= ActivePieceData.ShapeMatrix
	var GhostPos:	Vector2	= ActivePieceData.GhostPos
	var Pos:		Vector2	= ActivePieceData.Pos

	for x in range(ActivePieceData.ShapeMatrixWidth):
		for y in range(ActivePieceData.ShapeMatrixHeight):
			var ShouldDraw = ShapeMatrix[x][y] != 0

			if ShouldDraw:
				var ShapeOffset = Vector2(x, y)
				var BlockDrawPos = Pos + ShapeOffset
				var GhostDrawPos = GhostPos + ShapeOffset

				if Grid.Grid_IsInsidePlayArea(BlockDrawPos):
					var DrawPos		= ActivePiece_ToScreen(BlockDrawPos)
					var DrawColor	= Constants.COLORS[ActivePieceData.Type]
					var Rectangle	= Rect2(DrawPos, Grid.GRID_CELLSIZE)

					draw_rect(Rectangle, DrawColor)

				if Grid.Grid_IsInsidePlayArea(GhostDrawPos):
					var DrawPos		= ActivePiece_ToScreen(GhostDrawPos)
					var DrawColor	= Constants.COLORS[ActivePieceData.Type]
					var Rectangle	= Rect2(DrawPos, Grid.GRID_CELLSIZE)
					
					DrawColor.a = 0.35

					draw_rect(Rectangle, DrawColor)



func ActivePiece_SetActivePiece(Piece)	-> void:
	ActivePieceData.Pos = Vector2(0, 0)

	ActivePieceData.RotationState = 0
	ActivePieceData.Type = Piece.PieceType
	ActivePieceData.WallkickDataCW	= Piece.WallkickDataCW
	ActivePieceData.WallkickDataCCW	= Piece.WallkickDataCCW
	ActivePieceData.ShapeMatrixWidth  =	Piece.ShapeMatrixWidth
	ActivePieceData.ShapeMatrixHeight = Piece.ShapeMatrixHeight
	Matrix.CopyMatrix(ActivePieceData.ShapeMatrix, Piece.ShapeMatrix)
	
	ActivePiece_UpdateGhostPos()
	update()

func ActivePiece_UpdateGhostPos()		-> void:
	ActivePieceData.GhostPos = ActivePiece_GetHardDropPosition()

func ActivePiece_GetHardDropPosition()	-> Vector2:
	var NewPos: Vector2			= Vector2(ActivePieceData.Pos.x, ActivePieceData.Pos.y)
	var Coll:	int				= CollisionResult.NONE

	while true:
		Coll = Grid.Grid_HasCollisionWithShape(NewPos, ActivePieceData.ShapeMatrixWidth, ActivePieceData.ShapeMatrixHeight, ActivePieceData.ShapeMatrix)

		if Coll == CollisionResult.FLOOR:
			NewPos.y = NewPos.y - 1
			break
		else:
			NewPos.y = NewPos.y + 1

	return NewPos



func ActivePiece_MoveDown()		-> void:
	var NewPos: Vector2			= Vector2(ActivePieceData.Pos.x, ActivePieceData.Pos.y + 1)
	var Coll:	int				= Grid.Grid_HasCollisionWithShape(NewPos, ActivePieceData.ShapeMatrixWidth, ActivePieceData.ShapeMatrixHeight, ActivePieceData.ShapeMatrix)

	if Coll == CollisionResult.NONE:
		ActivePieceData.Pos.y = NewPos.y
		update()
		return

	if Coll == CollisionResult.FLOOR:
		emit_signal("ShouldLockPiece")

func ActivePiece_HardDrop()		-> void:
	var HardDropPos: Vector2	= ActivePiece_GetHardDropPosition()

	ActivePieceData.Pos.y = HardDropPos.y
	emit_signal("ShouldLockPiece")

func ActivePiece_MoveLeft()		-> void:
	var NewPos: Vector2			= Vector2(ActivePieceData.Pos.x - 1, ActivePieceData.Pos.y)
	var Coll:	int				= Grid.Grid_HasCollisionWithShape(NewPos, ActivePieceData.ShapeMatrixWidth, ActivePieceData.ShapeMatrixHeight, ActivePieceData.ShapeMatrix)
	
	if Coll == CollisionResult.NONE:
		ActivePieceData.Pos.x = NewPos.x

		ActivePiece_UpdateGhostPos()
		update()

func ActivePiece_MoveRight()	-> void:
	var NewPos: Vector2			= Vector2(ActivePieceData.Pos.x + 1, ActivePieceData.Pos.y)
	var Coll:	int				= Grid.Grid_HasCollisionWithShape(NewPos, ActivePieceData.ShapeMatrixWidth, ActivePieceData.ShapeMatrixHeight, ActivePieceData.ShapeMatrix)
	
	if Coll == CollisionResult.NONE:
		ActivePieceData.Pos.x = NewPos.x

		ActivePiece_UpdateGhostPos()
		update()

func ActivePiece_RotateCW()		-> void:
	if ActivePieceData.Type == 4:
		return

	var Coll:			int
	var WallkickOffset: Vector2
	var WallkickData:	Array = ActivePieceData.WallkickDataCW[ActivePieceData.RotationState]

	Matrix.CopyMatrix(ActivePieceData.CollisionMatrix, ActivePieceData.ShapeMatrix)
	Matrix.TransposeMatrix(ActivePieceData.CollisionMatrix, ActivePieceData.ShapeMatrixWidth, ActivePieceData.ShapeMatrixHeight)
	Matrix.ReverseRows(ActivePieceData.CollisionMatrix, ActivePieceData.ShapeMatrixWidth, ActivePieceData.ShapeMatrixHeight)

	Coll = Grid.Grid_HasCollisionWithShape(ActivePieceData.Pos, ActivePieceData.ShapeMatrixWidth, ActivePieceData.ShapeMatrixHeight, ActivePieceData.CollisionMatrix)

	if Coll != CollisionResult.NONE:
		for WallkickPos in WallkickData:
			Coll = Grid.Grid_HasCollisionWithShape(ActivePieceData.Pos + WallkickPos, ActivePieceData.ShapeMatrixWidth, ActivePieceData.ShapeMatrixHeight, ActivePieceData.CollisionMatrix)
			
			if Coll == CollisionResult.NONE:
				WallkickOffset = WallkickPos
				break

	if Coll == CollisionResult.NONE:
		Matrix.CopyMatrix(ActivePieceData.ShapeMatrix, ActivePieceData.CollisionMatrix)		
		ActivePieceData.RotationState += 1
	
		if ActivePieceData.RotationState == 4:
			ActivePieceData.RotationState = 0

		if WallkickOffset != null:
			ActivePieceData.Pos += WallkickOffset

		ActivePiece_UpdateGhostPos()
		update()

func ActivePiece_RotateCCW()	-> void:
	if ActivePieceData.Type == 4:
		return

	var Coll:			int
	var WallkickOffset: Vector2
	var WallkickData:	Array = ActivePieceData.WallkickDataCCW[ActivePieceData.RotationState]

	Matrix.CopyMatrix(ActivePieceData.CollisionMatrix, ActivePieceData.ShapeMatrix)
	Matrix.TransposeMatrix(ActivePieceData.CollisionMatrix, ActivePieceData.ShapeMatrixWidth, ActivePieceData.ShapeMatrixHeight)
	Matrix.ReverseCols(ActivePieceData.CollisionMatrix, ActivePieceData.ShapeMatrixWidth, ActivePieceData.ShapeMatrixHeight)

	Coll = Grid.Grid_HasCollisionWithShape(ActivePieceData.Pos, ActivePieceData.ShapeMatrixWidth, ActivePieceData.ShapeMatrixHeight, ActivePieceData.CollisionMatrix)

	if Coll != CollisionResult.NONE:
		for WallkickPos in WallkickData:
			Coll = Grid.Grid_HasCollisionWithShape(ActivePieceData.Pos + WallkickPos, ActivePieceData.ShapeMatrixWidth, ActivePieceData.ShapeMatrixHeight, ActivePieceData.CollisionMatrix)
			
			if Coll == CollisionResult.NONE:
				WallkickOffset = WallkickPos
				break

	if Coll == CollisionResult.NONE:
		Matrix.CopyMatrix(ActivePieceData.ShapeMatrix, ActivePieceData.CollisionMatrix)		
		ActivePieceData.RotationState -= 1
	
		if ActivePieceData.RotationState == -1:
			ActivePieceData.RotationState = 3

		if WallkickOffset != null:
			ActivePieceData.Pos += WallkickOffset

		ActivePiece_UpdateGhostPos()
		update()
