extends Node

var Settings:	Dictionary	= {}

func _ready()								-> void:
	if not SaveManager_LoadSettings():
		SaveManager_AssignDefaultSettings()

	SaveManager_LoadHighscores()


func SaveManager_SaveSettings()				-> void:
	var NewFile: File = File.new()

	NewFile.open(Constants.USER_SETTINGS_FILE, File.WRITE)
	NewFile.store_var(Settings)
	NewFile.close()

func SaveManager_AssignDefaultSettings() -> void:
	Settings = {
		"master_volume": -10,
		"music_volume": 0,
		"sound_effects_volume": 0,
	}
	SaveManager_SaveSettings()

func SaveManager_LoadSettings()				-> bool:
	var NewFile: File = File.new()

	if NewFile.file_exists(Constants.USER_SETTINGS_FILE):
		NewFile.open(Constants.USER_SETTINGS_FILE, File.READ)

		Settings = NewFile.get_var()

		NewFile.close()
		return true
		
	return false

func SaveManager_LoadHighscores()			-> bool:
	var NewFile: File = File.new()

	if NewFile.file_exists(Constants.HIGHSCORE_SAVEFILE):
		NewFile.open(Constants.HIGHSCORE_SAVEFILE, File.READ)

		PlayerInfo.Highscores = NewFile.get_var()

		NewFile.close()
		return true
		
	return false
	
func SaveManager_SaveHighscores()			-> void:
	var NewFile: File = File.new()

	NewFile.open(Constants.HIGHSCORE_SAVEFILE, File.WRITE)
	NewFile.store_var(PlayerInfo.Highscores)
	NewFile.close()
