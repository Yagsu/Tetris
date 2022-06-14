extends Popup

onready var MasterVolumeSlider			= $TabContainer/Audio/MarginContainer/GridContainer/MasterSlider
onready var MusicVolumeSlider			= $TabContainer/Audio/MarginContainer/GridContainer/MusicSlider
onready var SoundEffectsVolumeSlider	= $TabContainer/Audio/MarginContainer/GridContainer/SoundEffectsSlider

onready var MasterVolumeDBLabel 		= $TabContainer/Audio/MarginContainer/GridContainer/MasterLabel/VolumeLabel
onready var MusicVolumeDBLabel 			= $TabContainer/Audio/MarginContainer/GridContainer/MusicLabel/VolumeLabel
onready var SoundEffectVolumeDBLabel 	= $TabContainer/Audio/MarginContainer/GridContainer/SoundEffectsLabel/VolumeLabel


func _ready()										-> void:
	SettingsMenu_UpdateMasterVolume(SaveManager.Settings.master_volume)
	MasterVolumeSlider.value = SaveManager.Settings.master_volume;
	
	SettingsMenu_UpdateMusicVolume(SaveManager.Settings.music_volume)
	MusicVolumeSlider.value = SaveManager.Settings.music_volume
	
	SettingsMenu_UpdateSoundEffectsVolume(SaveManager.Settings.sound_effects_volume)
	SoundEffectsVolumeSlider.value = SaveManager.Settings.sound_effects_volume


func SettingsMenu_UpdateMasterVolume(Value)			-> void:
	AudioServer.set_bus_volume_db(0, Value)
	MasterVolumeDBLabel.set_text(str(Value," dB"))
	
func SettingsMenu_UpdateMusicVolume(Value)			-> void:
	AudioServer.set_bus_volume_db(1, Value)
	MusicVolumeDBLabel.set_text(str(Value," dB"))
	
func SettingsMenu_UpdateSoundEffectsVolume(Value)	-> void:
	AudioServer.set_bus_volume_db(2, Value)
	SoundEffectVolumeDBLabel.set_text(str(Value," dB"))


func _on_MasterSlider_value_changed(Value)			-> void:
	SettingsMenu_UpdateMasterVolume(Value)

	SaveManager.Settings.master_volume = Value;
	SaveManager.SaveManager_SaveSettings()

func _on_Music_Slider_value_changed(Value)			-> void:
	SettingsMenu_UpdateMusicVolume(Value)

	SaveManager.Settings.music_volume = Value
	SaveManager.SaveManager_SaveSettings()

func _on_SoundEffectsSlider_value_changed(Value)	-> void:
	SettingsMenu_UpdateSoundEffectsVolume(Value)

	SaveManager.Settings.sound_effects_volume = Value
	SaveManager.SaveManager_SaveSettings()
