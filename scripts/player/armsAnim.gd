extends Node3D

@onready var arms_anim = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.reload.connect(PlayReload)


func PlayReload():
	arms_anim.play("Global/reload")
