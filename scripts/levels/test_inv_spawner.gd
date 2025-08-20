extends Node

@onready var player_spawn: Marker3D = $"../area1/player_spawn"
var lvlallspawn: Array

func _ready() -> void:
	lvlallspawn = []
