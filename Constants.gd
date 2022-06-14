extends Node2D

const COLORS = [
				Color(0, 0, 0, 1),
				Color(0.3, 0.5, 0.8, 1),
				Color(0.1, 0.13, 0.6, 1),
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

enum PieceTypes {I, J, L, O, S, T, Z}