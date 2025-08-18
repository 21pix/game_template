extends Node3D
class_name npc_muzzle_flash

@onready var MFlash: GPUParticles3D = $GPUParticles3D
@onready var bullet_trail: GPUParticles3D = $BulletTrail


func npc_muzzle_flash():
	MFlash.emitting = true
	bullet_trail.emitting = true
