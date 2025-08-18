extends Node3D

@onready var gun_anim = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.reload.connect(PlayReload)


func PlayReload():
	gun_anim.play("Global/reload")
