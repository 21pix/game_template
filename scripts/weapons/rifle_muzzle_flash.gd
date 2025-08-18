extends Node3D

@onready var MTrail: GPUParticles3D = $MuzzleTrail
@onready var MFlash: GPUParticles3D = $MuzzleFlash
@onready var muzzle_light = $MuzzleLight
@onready var light_timer = $LightTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.shotfired.connect(RunMuzzleFlash)

func RunMuzzleFlash():
	MFlash.emitting = true
	MTrail.emitting = true
	muzzle_light.visible = true
	light_timer.start(0.1)
# Called every frame. 'delta' is the elapsed time since the previous frame.



func _on_light_timer_timeout() -> void:
	muzzle_light.visible = false
