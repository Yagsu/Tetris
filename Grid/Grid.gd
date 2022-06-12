extends Node2D

const GRID_WIDTH: 		 int = 10
const GRID_HEIGHT:		 int = 23
const GRID_MATRIXSIZE:	 int = GRID_WIDTH * GRID_HEIGHT
const GRID_CELLSIZE		 := Vector2(48, 48)
const GRID_HALFCELLSIZE	 := GRID_CELLSIZE * 0.5

var GridMatrix:			Array
var Initialized: 		bool = false

signal ShouldLockPiece


func _ready():
	Grid_Initialize()



func Grid_Initialize() -> void:
	if Initialized:
		return

	GridMatrix = Matrix.CreateMatrix(GRID_WIDTH, GRID_HEIGHT)

	Initialized = true

func Grid_Reset() -> void:
	if not Initialized:
		return

	for i in range(GRID_WIDTH * GRID_HEIGHT):
			GridMatrix[i] = 0



func Grid_IsInitialized() -> bool:
	return Initialized

func Grid_IsWall(Pos: Vector2) -> bool:
	return Pos.x <= -1 or Pos.x >= GRID_WIDTH

func Grid_IsFloor(Pos: Vector2) -> bool:
	return Pos.y >= GRID_HEIGHT

func Grid_IsInsideGrid(Pos: Vector2) -> bool:
	return Pos.x >= 0 and Pos.x < GRID_WIDTH and Pos.y >= 0 and Pos.y < GRID_HEIGHT

func Grid_IsInsidePlayArea(Pos: Vector2) -> bool:
	return Pos.y >=2 and Pos.y < GRID_HEIGHT

func Grid_IsEmptyPosition(Pos: Vector2) -> bool:
	if not Initialized:
		return false

	if Grid_IsInsideGrid(Pos):
		return GridMatrix[Pos.x][Pos.y] == 0

	return false



func Grid_GetValueAt(Pos: Vector2) -> int:
	if not Grid_IsInsideGrid(Pos):
		return -1

	return GridMatrix[Pos.x][Pos.y]

func Grid_SetValueAt(Pos: Vector2, Value: int) -> void:
	if not Grid_IsInsideGrid(Pos):
		return

	GridMatrix[Pos.x][Pos.y] = Value



func Grid_AddShape(Pos: Vector2, ShapeWidth: int, ShapeHeight: int, Shape: Array) -> void:
	var Width:  int	= min(ShapeWidth, Shape.size())
	var Height: int = min(ShapeHeight, Shape[0].size())

	if Width > 0 and Height > 0:
		for x in range(Width):
			for y in range(Height):
				var ShapeValue: int = Shape[x][y]

				if ShapeValue != 0:
					Grid_SetValueAt(Pos + Vector2(x, y), ShapeValue)

func Grid_HasCollisionWithShape(Pos: Vector2, ShapeWidth: int, ShapeHeight: int, Shape: Array, LockPiece: bool = false) -> bool:
	var Width:  int	= min(ShapeWidth, Shape.size())
	var Height: int = min(ShapeHeight, Shape[0].size())

	if Width > 0 and Height > 0:
		for x in range(Width):
			for y in range(Height):
				if Shape[x][y] != 0:
					var GridPos: Vector2 = Vector2(Pos.x + x, Pos.y + y)

					if Grid_IsWall(GridPos):
						return true
						
					if Grid_IsFloor(GridPos) or GridMatrix[GridPos.x][GridPos.y] != 0:
						if LockPiece:
							emit_signal("ShouldLockPiece")
						return true


	return false