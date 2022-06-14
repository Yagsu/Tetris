extends Node2D

signal ShouldLockPiece
signal ShouldEndGame
signal PieceHardDrop(CellCount)
signal PieceSoftDrop

onready var DropTimer = $DropTimer

var		PieceSprites: Array	= []
var		GhostSprites: Array	= []

var	SoftDropActive	= false
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


func _ready()				-> void:
	for i in range(4 * 4):
		var PieceSprite = Sprite.new()
		var GhostSprite = Sprite.new()

		PieceSprite.texture	= Constants.BLOCK_SPRITE
		PieceSprite.visible	= false

		GhostSprite.texture = Constants.GHOST_SPRITE
		GhostSprite.visible = false

		PieceSprites.append(PieceSprite)
		GhostSprites.append(GhostSprite)

		add_child(PieceSprite)
		add_child(GhostSprite)

func _draw()				-> void:
	ActivePiece_UpdateGhostPos()
	ActivePiece_Draw()

func _process(Delta: float) -> void:
	if Input.is_action_just_pressed("TETRIS_TURN_CW"):
		ActivePiece_RotateCW()
		
	if Input.is_action_just_pressed("TETRIS_TURN_CCW"):
		ActivePiece_RotateCCW()
		
	if Input.is_action_just_pressed("TETRIS_SOFT_DROP"):
		SoftDropActive = true
		DropTimer.wait_time = DropTimer.wait_time * 0.2
		DropTimer.start()

	if Input.is_action_just_released("TETRIS_SOFT_DROP"):
		SoftDropActive = false
		DropTimer.wait_time = DropTimer.wait_time * 5
		DropTimer.start()

	if Input.is_action_just_pressed("TETRIS_MOVE_LEFT"):
		ActivePiece_MoveLeft()
	
	if Input.is_action_just_pressed("TETRIS_MOVE_RIGHT"):
		ActivePiece_MoveRight()

	if Input.is_action_just_pressed("TETRIS_HARD_DROP"):
		ActivePiece_HardDrop()


func ActivePiece_Reset()				-> void:
	ActivePiece_HideSprites()

func ActivePiece_HideSprites()			-> void:
	for i in range(4 * 4):
		PieceSprites[i].visible = false
		GhostSprites[i].visible = false

func ActivePiece_ToScreen(Pos: Vector2) -> Vector2:
	return Pos * Grid.GRID_CELLSIZE - Grid.GRID_VANISHZONEOFFSET

func ActivePiece_Draw()					-> void:
	var ShapeMatrix: Array	= ActivePieceData.ShapeMatrix
	var GhostPos:	Vector2	= ActivePieceData.GhostPos
	var Pos:		Vector2	= ActivePieceData.Pos

	ActivePiece_HideSprites()

	for x in range(ActivePieceData.ShapeMatrixWidth):
		for y in range(ActivePieceData.ShapeMatrixHeight):
			var ShouldDraw = ShapeMatrix[x][y] != 0

			if ShouldDraw:
				var ShapeOffset		= Vector2(x, y)
				var BlockDrawPos	= Pos + ShapeOffset
				var GhostDrawPos	= GhostPos + ShapeOffset

				if Grid.Grid_IsInsidePlayArea(BlockDrawPos):
					var PieceSprite	= PieceSprites[y * 4 + x]

					PieceSprite.position		= ActivePiece_ToScreen(BlockDrawPos) + Grid.GRID_HALFCELLSIZE
					PieceSprite.self_modulate	= Constants.COLORS[ActivePieceData.Type]
					PieceSprite.visible			= true

				if Grid.Grid_IsInsidePlayArea(GhostDrawPos):
					var GhostSprite	= GhostSprites[y * 4 + x]

					GhostSprite.position		= ActivePiece_ToScreen(GhostDrawPos) + Grid.GRID_HALFCELLSIZE
					GhostSprite.self_modulate	= Constants.COLORS[ActivePieceData.Type]
					GhostSprite.self_modulate.a = 0.4
					GhostSprite.visible			= true




func ActivePiece_SetActivePiece(Piece)	-> void:
	var Coll: int
	
	ActivePieceData.Pos = Piece.SpawnPos
	ActivePieceData.RotationState	= 0
	ActivePieceData.Type			= Piece.PieceType
	ActivePieceData.WallkickDataCW	= Piece.WallkickDataCW
	ActivePieceData.WallkickDataCCW	= Piece.WallkickDataCCW
	ActivePieceData.ShapeMatrixWidth  =	Piece.ShapeMatrixWidth
	ActivePieceData.ShapeMatrixHeight = Piece.ShapeMatrixHeight
	Matrix.CopyMatrix(ActivePieceData.ShapeMatrix, Piece.ShapeMatrix)

	Coll = Grid.Grid_HasCollisionWithShape(ActivePieceData.Pos, ActivePieceData.ShapeMatrixWidth, ActivePieceData.ShapeMatrixHeight, ActivePieceData.ShapeMatrix)

	if Coll == CollisionResult.FLOOR:
		emit_signal("ShouldEndGame")
		return 

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


func ActivePiece_ToggleSoftDrop()	-> void:
	if SoftDropActive:
		SoftDropActive = false
		DropTimer.wait_time = DropTimer.wait_time * 5
		DropTimer.start()
	else:
		SoftDropActive = true
		DropTimer.wait_time = DropTimer.wait_time * 0.2
		DropTimer.start()

func ActivePiece_MoveDown()			-> void:
	var NewPos: Vector2			= Vector2(ActivePieceData.Pos.x, ActivePieceData.Pos.y + 1)
	var Coll:	int				= Grid.Grid_HasCollisionWithShape(NewPos, ActivePieceData.ShapeMatrixWidth, ActivePieceData.ShapeMatrixHeight, ActivePieceData.ShapeMatrix)

	if Coll == CollisionResult.NONE:
		if SoftDropActive:
			emit_signal("PieceSoftDrop")

		ActivePieceData.Pos.y = NewPos.y
		update()
		return

	if Coll == CollisionResult.FLOOR:
		if Grid.Grid_IsShapeInsidePlayArea(ActivePieceData.Pos, ActivePieceData.ShapeMatrixWidth, ActivePieceData.ShapeMatrixHeight, ActivePieceData.ShapeMatrix):	
			emit_signal("ShouldLockPiece")
		else:
			emit_signal("ShouldEndGame")

func ActivePiece_HardDrop()		-> void:
	var HardDropPos: Vector2	= ActivePiece_GetHardDropPosition()
	var CellCount:	 int		= ActivePieceData.Pos.distance_to(HardDropPos)	

	if not Grid.Grid_IsShapeInsidePlayArea(HardDropPos, ActivePieceData.ShapeMatrixWidth, ActivePieceData.ShapeMatrixHeight, ActivePieceData.ShapeMatrix):
		emit_signal("ShouldEndGame")
		return

	ActivePieceData.Pos.y = HardDropPos.y
	emit_signal("PieceHardDrop", CellCount)
	emit_signal("ShouldLockPiece")

func ActivePiece_MoveLeft()		-> void:
	var NewPos: Vector2			= Vector2(ActivePieceData.Pos.x - 1, ActivePieceData.Pos.y)
	var Coll:	int				= Grid.Grid_HasCollisionWithShape(NewPos, ActivePieceData.ShapeMatrixWidth, ActivePieceData.ShapeMatrixHeight, ActivePieceData.ShapeMatrix)
	
	if Coll == CollisionResult.NONE:
		ActivePieceData.Pos.x = NewPos.x
		update()

func ActivePiece_MoveRight()	-> void:
	var NewPos: Vector2			= Vector2(ActivePieceData.Pos.x + 1, ActivePieceData.Pos.y)
	var Coll:	int				= Grid.Grid_HasCollisionWithShape(NewPos, ActivePieceData.ShapeMatrixWidth, ActivePieceData.ShapeMatrixHeight, ActivePieceData.ShapeMatrix)
	
	if Coll == CollisionResult.NONE:
		ActivePieceData.Pos.x = NewPos.x
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

		update()


func _on_DropTimer_timeout():
	ActivePiece_MoveDown()
