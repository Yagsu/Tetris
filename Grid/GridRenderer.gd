extends Node2D

var		CellSprites: Array	= []
var		BlockClearParticle = preload("res://Scenes/UI/Particles/BlockClearParticle.tscn")

func _ready()					-> void:
	Grid.connect("GridUpdate", self, "update")
	Grid.connect("SpawnBlockClearParticle", self, "GridRenderer_OnSpawnClearParticle")

	for i in range(Grid.GRID_WIDTH * Grid.GRID_HEIGHT):
		var SpritePos = Vector2((i % Grid.GRID_WIDTH), floor(i / (Grid.GRID_WIDTH)))
		var CellSprite = Sprite.new()	

		CellSprite.position = GridRenderer_ToScreen(SpritePos) + Grid.GRID_HALFCELLSIZE
		CellSprite.texture	= Constants.BLOCK_SPRITE
		CellSprite.visible	= false

		CellSprites.append(CellSprite)
		add_child(CellSprite)

func _draw()					-> void:
	GridRenderer_Draw()


func GridRenderer_Reset()		-> void:
	update()

func GridRenderer_Draw()		-> void:
	assert(Grid.Grid_IsInitialized())

	for x in range(Grid.GRID_WIDTH):
		for y in range(3, Grid.GRID_HEIGHT):
			var GridPos:	Vector2	= Vector2(x, y)
			var GridValue: 	int		= Grid.Grid_GetValueAt(GridPos)
			var CellSprite:	Sprite	= CellSprites[y * Grid.GRID_WIDTH + x]
			
			if GridValue != 0:
				CellSprite.self_modulate = Constants.COLORS[GridValue]
				CellSprite.visible = true
			else:
				CellSprite.visible = false

func GridRenderer_ToScreen(Pos: Vector2) -> Vector2:
	return Pos * Grid.GRID_CELLSIZE - Grid.GRID_VANISHZONEOFFSET


func GridRenderer_OnSpawnClearParticle(Position: Vector2, Col: int)	-> void:
	var ParticleScreenPos:	Vector2		= GridRenderer_ToScreen(Position) + Grid.GRID_HALFCELLSIZE
	var ParticleColor:		Color		= Constants.COLORS[Col]
	var Particle						= BlockClearParticle.instance()

	Particle.position		= ParticleScreenPos
	Particle.self_modulate	= ParticleColor
	Particle.emitting		= true

	add_child(Particle)
