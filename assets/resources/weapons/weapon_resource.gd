extends Resource
class_name WeaponClass

@export var Weapon_Name : String
@export var Weapon_Type : String
@export var inv_name: String
@export var item_name: String
@export var inv_icon: Texture2D

@export_subgroup("Model")
@export var model: PackedScene  # Model of the weapon
@export var position: Vector3  # On-screen position
@export var rotation: Vector3  # On-screen rotation
@export var muzzle_position = Vector3(0, -0.02, 0.95)  # On-screen position of muzzle flash
@export var muzzle_size = 0.2
@export var muzzle_anim: String

@export_subgroup("Properties")
@export var cooldown: float = 0.1  # Firerate
@export var reload_time = 1.0 #Reload time elapsed, stops shoot
@export var max_distance: int = 100  # Fire distance
@export var damage: float = 25  # Damage per hit
@export var spread: float = 0.1  # Spread of each shot
@export_range(1, 8) var shot_count: int = 1  # Amount of shots
@export_range(0, 50) var knockback: int = 20  # Amount of knockback
@export var recoil : Vector3
@export var aimRecoil : Vector3

@export var aimPos = Vector3(0, -0.085, 0)
@export var snappiness : float
@export var returnSpeed : float

@export_subgroup("Sounds")
@export var sound_shoot: AudioStreamMP3  # Sound path
@export var sound_reload: AudioStreamMP3

@export_subgroup("Ammunition")
@export var Current_Ammo : int
@export var Reserve_Ammo : int
@export var Magazine : int
@export var Max_Ammo : int

@export var Auto_Fire : bool
