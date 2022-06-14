extends Node2D

const BLOCK_SPRITE = preload("res://Assets/Images/RetmisBlockSprite.png")
const GHOST_SPRITE = preload("res://Assets/Images/RetmisGhostBlockSprite.png")

const USER_SETTINGS_FILE = "user://user_settings.txt"
const HIGHSCORE_SAVEFILE = "user://highscores"

const COLORS = [
				Color(1, 1, 1, 1),
				Color(0.3, 0.5, 0.8, 1),
				Color(0.2, 0.3, 0.6, 1),
				Color(1, 0.5, 0.275, 1),
				Color(1, 0.8, 0.05, 1),
				Color(0.6, 1.0, 0.6, 1),
				Color(0.7, 0.2, 0.9, 1),
				Color(0.7, 0.07, 0.2, 1),
]

const JLTSZ_WALLKICK_CW = [
	[Vector2(-1, 0), Vector2(-1, -1), Vector2(0, 2), Vector2(-1, 2)],
	[Vector2(1, 0), Vector2(1, 1), Vector2(0, -2), Vector2(1, -2)],
	[Vector2(1, 0), Vector2(1, -1), Vector2(0, 2), Vector2(1, 2)],
	[Vector2(-1, 0), Vector2(-1, 1), Vector2(0, -2), Vector2(-1, -2)],
]

const JLTSZ_WALLKICK_CCW = [
	[Vector2(1, 0), Vector2(1, -1), Vector2(0, 2), Vector2(1, 2)],
	[Vector2(1, 0), Vector2(1, 1), Vector2(0, -2), Vector2(1, -2)],
	[Vector2(-1, 0), Vector2(-1, -1), Vector2(0, -2), Vector2(-1, 2)],
	[Vector2(-1, 0), Vector2(-1, 1), Vector2(0, -2), Vector2(-1, -2)],
]

const I_WALLKICK_CW = [
	[Vector2(-2, 0), Vector2(1, 0), Vector2(-2, 1), Vector2(1, -2)],
	[Vector2(-1, 0), Vector2(2, 0), Vector2(-1, -2), Vector2(2, 1)],
	[Vector2(2, 0), Vector2(-1, 0), Vector2(2, -1), Vector2(-1, 2)],
	[Vector2(1, 0), Vector2(-2, 0), Vector2(1, 2), Vector2(-2, -1)],
]

const I_WALLKICK_CCW = [
	[Vector2(-1, 0), Vector2(2, 0), Vector2(-1, -2), Vector2(2, 1)],
	[Vector2(2, 0), Vector2(-1, 0), Vector2(2, -1), Vector2(-1, 2)],
	[Vector2(1, 0), Vector2(-2, 0), Vector2(1, 2), Vector2(-2, -1)],
	[Vector2(-2, 0), Vector2(1, 0), Vector2(-2, 1), Vector2(1, -2)],
]

const MAX_SCORE = 2500
