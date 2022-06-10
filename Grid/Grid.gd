extends Node2D

var Width = 10
var Height = 23
var CellSize = Vector2(48, 48)
var HalfCellSize = CellSize * 0.5
var Grid = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(Width):
		Grid.append([])
		for y in range(Height):
			Grid[x].append(0)

func _draw():
	Grid_Draw()

func Grid_Draw():
	for x in range(Width):
		for y in range(Height):
			var GridPos = Vector2(x, y)
			var Pos = Grid_ToScreen(GridPos)
			var Col = Color(0.1 * x, 0.05 * y, 0, lerp(0, 1, min(Grid_GetDistanceToFloor(GridPos), Grid_GetDistanceToClosestWall(GridPos)) / 4))
			var GridRect = Rect2(Pos, CellSize)

			draw_rect(GridRect, Col)

func Grid_ToScreen(Pos):
	return position + Pos * CellSize

func Grid_IsWall(Pos):
	return Pos.x == -1 or Pos.x == 10

func Grid_IsFloor(Pos):
	return Pos.y == 23

func Grid_IsEmptyPosition(Pos):
	if Pos.x > 0 and Pos.x < Width and Pos.y > 0 and Pos.y < Height:
		return Grid[Pos.x][Pos.y] == 0



# DEBUG


func Grid_GetDistanceToClosestWall(Pos):
	var PosHeight = Pos.y
	var LeftWall = Vector2(-1, PosHeight)
	var RightWall = Vector2(10, PosHeight)

	var DistToRight = Pos.distance_to(RightWall)
	var DistToLeft = Pos.distance_to(LeftWall)

	return min(DistToLeft, DistToRight)

func Grid_GetDistanceToFloor(Pos):
	var FloorPos = Vector2(Pos.x, 23)

	return Pos.distance_to(FloorPos)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	update()
