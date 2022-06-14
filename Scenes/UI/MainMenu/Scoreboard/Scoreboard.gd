extends Popup

onready var ScoreContainer : VBoxContainer = $Panel/MainVBox/ScrollContainer/ScoreContainer

func _ready()												-> void:
	if PlayerInfo.Highscores.size() == 0:
		return
	
	Scoreboard_UpdateScoreboard()
	

func Scoreboard_UpdateScoreboard()							-> void:
	for Score in PlayerInfo.Highscores:
		Scoreboard_AddScoreLable(Score[0], Score[1])

func Scoreboard_AddScoreLable(Username: String, Score: int) -> void:
	var ScoreLabel = Label.new()

	ScoreLabel.rect_min_size.y = 40

	ScoreLabel.set_text(str(ScoreContainer.get_child_count() + 1, ". ", Score, " < %s > " % Username))
	ScoreContainer.add_child(ScoreLabel)
