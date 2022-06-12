extends Node2D

var ActivePieceData = {
	Type	= -1,
	Pos		= Vector2(0, 0),
	RotationState		= 0,
	ShapeMatrixWidth	= 4,
	ShapeMatrixHeight	= 4,
	ShapeMatrix			= [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
	CollisionMatrix		= [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
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

func ActivePiece_ToScreen(Pos: Vector2) -> Vector2:
	return Pos * Grid.GRID_CELLSIZE

func ActivePiece_Draw() ->	void:
	var ShapeMatrix: Array	= ActivePieceData.ShapeMatrix
	var Pos: Vector2		= ActivePieceData.Pos

	for x in range(ActivePieceData.ShapeMatrixWidth):
		for y in range(ActivePieceData.ShapeMatrixHeight):
			var ShouldDraw = ShapeMatrix[x][y] != 0

			if ShouldDraw:
				var Col =	Color(1, 1, 0, 0.75)
				var DrawPos =	ActivePiece_ToScreen(Pos + Vector2(x, y))
				var Rectangle = Rect2(DrawPos, Grid.GRID_CELLSIZE)

				draw_rect(Rectangle, Col)



func ActivePiece_MoveDown() ->	void:
	var NewPos = Vector2(ActivePieceData.Pos.x, ActivePieceData.Pos.y + 1)
	
	if not Grid.Grid_HasCollisionWithShape(NewPos, ActivePieceData.ShapeMatrixWidth, ActivePieceData.ShapeMatrixHeight, ActivePieceData.ShapeMatrix, true):
		ActivePieceData.Pos.y = NewPos.y

	update()	

func ActivePiece_MoveLeft()		-> void:
	var NewPos = Vector2(ActivePieceData.Pos.x - 1, ActivePieceData.Pos.y)
	
	if not Grid.Grid_HasCollisionWithShape(NewPos, ActivePieceData.ShapeMatrixWidth, ActivePieceData.ShapeMatrixHeight, ActivePieceData.ShapeMatrix):
		ActivePieceData.Pos.x = NewPos.x

	update()	

func ActivePiece_MoveRight()	-> void:
	var NewPos = Vector2(ActivePieceData.Pos.x + 1, ActivePieceData.Pos.y)
	
	if not Grid.Grid_HasCollisionWithShape(NewPos, ActivePieceData.ShapeMatrixWidth, ActivePieceData.ShapeMatrixHeight, ActivePieceData.ShapeMatrix):
		ActivePieceData.Pos.x = NewPos.x

	update()	

func ActivePiece_RotateCW()		-> void:
	Matrix.CopyMatrix(ActivePieceData.CollisionMatrix, ActivePieceData.ShapeMatrix)
	Matrix.TransposeMatrix(ActivePieceData.CollisionMatrix)
	Matrix.ReverseRows(ActivePieceData.CollisionMatrix)

	if not Grid.Grid_HasCollisionWithShape(ActivePieceData.Pos, ActivePieceData.ShapeMatrixWidth, ActivePieceData.ShapeMatrixHeight, ActivePieceData.CollisionMatrix):
		Matrix.CopyMatrix(ActivePieceData.ShapeMatrix, ActivePieceData.CollisionMatrix)		
		ActivePieceData.RotationState += 1
	
		if ActivePieceData.RotationState == 4:
			ActivePieceData.RotationState = 0
			
		update()

func ActivePiece_RotateCCW()	-> void:
	Matrix.CopyMatrix(ActivePieceData.CollisionMatrix, ActivePieceData.ShapeMatrix)
	Matrix.TransposeMatrix(ActivePieceData.CollisionMatrix)
	Matrix.ReverseCols(ActivePieceData.CollisionMatrix)

	if not Grid.Grid_HasCollisionWithShape(ActivePieceData.Pos, ActivePieceData.ShapeMatrixWidth, ActivePieceData.ShapeMatrixHeight, ActivePieceData.CollisionMatrix):
		Matrix.CopyMatrix(ActivePieceData.ShapeMatrix, ActivePieceData.CollisionMatrix)		
		ActivePieceData.RotationState -= 1
	
		if ActivePieceData.RotationState == -1:
			ActivePieceData.RotationState = 3

		update()
