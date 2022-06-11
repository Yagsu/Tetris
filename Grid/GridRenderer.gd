extends Node2D

const DrawColors = [Color(0, 0, 0), Color(1, 0, 0)]

func _ready():
	pass

func _draw() -> void:
	GridRenderer_Draw()

func GridRenderer_Draw() -> void:
	if not Grid.Grid_IsInitialized():
		return

	for x in range(Grid.GRID_WIDTH):
		for y in range(Grid.GRID_HEIGHT):
			var GridPos = Vector2(x, y)
			
			var Pos = GridRenderer_ToScreen(GridPos)
			var Col = Color(0, 0, 0)
			
			var GridValue = Grid.Grid_GetValueAt(GridPos)

			if GridValue == 1:
				Col = Color(1, 0, 0)


			var GridRect = Rect2(Pos, Grid.GRID_CELLSIZE)

			draw_rect(GridRect, Col)


func GridRenderer_ToScreen(Pos: Vector2) -> Vector2:
	return Pos * Grid.GRID_CELLSIZE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update()
