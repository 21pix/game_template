extends Resource
class_name character_weapon

@export_subgroup("Weapon")
@export var wpn_name: String
@export var wpn_ammo: String
@export var wpn_model: PackedScene
@export var wpn_sound: AudioStreamMP3
@export var wpn_position: Vector3  # On-screen position
@export var wpn_rotation: Vector3  # On-screen rotation

@export var max_distance: int = 100  # Fire distance
@export var damage: float = 25  # Damage per hit
@export var spread: float = 0.1  # Spread of each shot
@export var shot_count: int = 1  # Amount of shots
@export var shot_time: float = 1.0

@export_subgroup("MuzzleFlash")
@export var muz_model: PackedScene
@export var muz_position: Vector3  # On-screen position
@export var muz_rotation: Vector3  # On-screen rotation
