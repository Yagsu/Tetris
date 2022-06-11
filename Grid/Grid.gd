extends Node2D

const GRID_WIDTH: 		 int = 10
const GRID_HEIGHT:		 int = 23
const GRID_MATRIXSIZE:	 int = GRID_WIDTH * GRID_HEIGHT
const GRID_CELLSIZE:	 Vector2 = Vector2(48, 48)
const GRID_HALFCELLSIZE: Vector2 = GRID_CELLSIZE * 0.5

var GridMatrix:			Array
var GridPositionOffset: Vector2
var Initialized: 		bool = false


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

func Grid_IsEmptyPosition(Pos: Vector2) -> bool:
	if not Initialized:
		return false

	if Pos.x > 0 and Pos.x < GRID_WIDTH and Pos.y > 0 and Pos.y < GRID_HEIGHT:
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


# DEBUG


func Grid_GetDistanceToClosestWall(Pos) -> float:
	var PosHeight = Pos.y
	var LeftWall = Vector2(-1, PosHeight)
	var RightWall = Vector2(10, PosHeight)

	var DistToRight = Pos.distance_to(RightWall)
	var DistToLeft = Pos.distance_to(LeftWall)

	return min(DistToLeft, DistToRight)

func Grid_GetDistanceToFloor(Pos) -> float:
	var FloorPos = Vector2(Pos.x, 23)

	return Pos.distance_to(FloorPos)
