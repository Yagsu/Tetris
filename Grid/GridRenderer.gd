extends Node2D
	

func _ready():
	pass

func _draw() -> void:
	GridRenderer_Draw()


func GridRenderer_Draw() -> void:
	if not Grid.Grid_IsInitialized():
		return

	for x in range(Grid.GRID_WIDTH):
		for y in range(2, Grid.GRID_HEIGHT):
			var GridPos: Vector2 = Vector2(x, y)
			var GridValue = Grid.Grid_GetValueAt(GridPos)
			
			var Pos = GridRenderer_ToScreen(GridPos)
			var Col = Constants.COLORS[GridValue]
			var GridRect = Rect2(Pos, Grid.GRID_CELLSIZE)

			draw_rect(GridRect, Col)


func GridRenderer_ToScreen(Pos: Vector2) -> Vector2:
	return Pos * Grid.GRID_CELLSIZE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update()
