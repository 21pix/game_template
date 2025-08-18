extends Node3D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var inter_sound = preload("res://sounds/blaster.ogg")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		play_sound()
		
func play_sound():
	audio_stream_player.stream = inter_sound
	audio_stream_player.play()
