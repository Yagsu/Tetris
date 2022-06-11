extends Node2D

onready var ActivePiece = ($GridRenderer/ActivePiece)
onready var ActivePieceData = ActivePiece.ActivePieceData


# Called when the node enters the scene tree for the first time.
func _ready():
	var TestPiece = $GridRenderer/TestPiece

	TestPiece.SetAsCurrentPiece(ActivePieceData)

	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	ActivePiece.ActivePiece_MoveDown()
	pass # Replace with function body.
