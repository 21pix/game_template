extends Node
@onready var npc_sound_player: AudioStreamPlayer3D = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	npc_sound_player.set_max_polyphony(3)
