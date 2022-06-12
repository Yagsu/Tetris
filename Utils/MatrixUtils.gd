extends Node

const TempMatrixWidth:  int	= 4
const TempMatrixHeight: int	= 4
var Temp4x4Matrix:	Array	= [[0, 1, 0, 0], [0, 1, 0, 0], [0, 1, 0, 0], [0, 1, 0, 0]]


func CreateMatrix(Width: int, Height: int, Value: int = 0) -> Array:
	var NewMatrix: Array = []

	for x in range(Width):
		NewMatrix.append([])
		for y in range(Height):
			NewMatrix[x].append(Value)

	return NewMatrix


func FillMatrix(Matrix: Array, Value: int, Width: int, Height: int) -> void:
	if Width < 0 or Height < 0:
		return
	
	Width	= min(Matrix.size(), Width)
	Height	= min(Matrix[0].size(), Height)

	for x in range(Width):
		for y in range(Height):
			Matrix[x][y] = Value


func CopyMatrix(Dest: Array, Source: Array) -> void:
	var Width: 	int	= min(Dest.size(), Source.size())
	var Height: int = min(Dest[0].size(), Source[0].size())

	for x in range(Width):
		for y in range(Height):
			Dest[x][y] = Source[x][y]


func TransposeMatrix(Matrix: Array) -> Array:
	var Width:	int = Matrix.size()
	var Height: int = Matrix[0].size()
	
	if Width <= TempMatrixWidth and Height <= TempMatrixHeight:
		return _TransposeCopy(Matrix, Width, Height)

	return _TransposeNew(Matrix, Width, Height)

func _TransposeCopy(Matrix: Array, Width: int, Height: int) -> Array:
	for x in range(Width):
		for y in range(Height):
			Temp4x4Matrix[x][y] = Matrix[y][x]
			
	CopyMatrix(Matrix, Temp4x4Matrix)
	return Matrix

func _TransposeNew(Matrix: Array, Width: int, Height: int) -> Array:
	var NewMatrix: Array = CreateMatrix(Width, Height)

	for x in range(Width):
		for y in range(Height):
			NewMatrix[x][y] = Matrix[y][x]
	
	return NewMatrix


func ReverseRows(Matrix: Array) -> Array:
	var Width:	int = Matrix.size()
	var Height: int = Matrix[0].size()
	
	if Width <= TempMatrixWidth and Height <= TempMatrixHeight:
		return _ReverseRowsCopy(Matrix, Width, Height)
		
	return _ReverseRowsNew(Matrix, Width, Height)
	
func _ReverseRowsCopy(Matrix: Array, Width: int, Height: int) -> Array:
	for x in range(Width):
		for y in range(Height):
			Temp4x4Matrix[x][y] = Matrix[Width - 1 - x][y]
	
	CopyMatrix(Matrix, Temp4x4Matrix)
	return Matrix
		
func _ReverseRowsNew(Matrix: Array, Width: int, Height: int) -> Array:
	var NewMatrix: Array = CreateMatrix(Width, Height)

	for x in range(Width):
		for y in range(Height):
			NewMatrix[x][y] = Matrix[Width - 1 - x][y]

	return NewMatrix


func ReverseCols(Matrix: Array) -> Array:
	var Width:	int = Matrix.size()
	var Height: int = Matrix[0].size()

	if Width <= TempMatrixWidth and Height <= TempMatrixHeight:
		return _ReverseColsCopy(Matrix, Width, Height)

	return _ReverseColsNew(Matrix, Width, Height)

func _ReverseColsCopy(Matrix: Array, Width: int, Height: int) -> Array:
	for x in range(Width):
		for y in range(Height):
			Temp4x4Matrix[x][y] = Matrix[x][Height - 1 - y]

	CopyMatrix(Matrix, Temp4x4Matrix)
	return Matrix

func _ReverseColsNew(Matrix: Array, Width: int, Height: int) -> Array:
	var NewMatrix: Array = CreateMatrix(Width, Height)

	for x in range(Width):
		for y in range(Height):
			NewMatrix[x][y] = Matrix[x][Height - 1 - y]

	return NewMatrix
