extends Node

static func	ScoreManager_Sort(a, b)							-> bool:
	if a[1] > b[1]:
		return true
	
	return false

func ScoreManager_SortHighscores()							-> void:
	PlayerInfo.Highscores.sort_custom(self, "ScoreManager_Sort")

func ScoreManager_AddNewScore(Username: String, Score: int) -> void:
	PlayerInfo.Highscores.append([Username, Score])
	ScoreManager_SortHighscores()
	SaveManager.SaveManager_SaveHighscores()

func ScoreManager_GetScoreForUser(Username: String)			-> int:
	for Score in PlayerInfo.Highscores:
		if Score[0] == Username:
			return Score[1]
			
	return 0
