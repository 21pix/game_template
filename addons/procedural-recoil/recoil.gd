class_name ProceduralRecoil
extends Node3D

# Rotations
var currentRotation : Vector3
var targetRotation : Vector3
var weaponname
@onready var weapon_container: Node3D = $Camera/WeaponContainer

@export_category("Recoil Vectors")
@export var pistol_recoil : Vector3
@export var pistol_aimRecoil : Vector3
@export var pistol_zRecoil : float
@export var shotgun_recoil : Vector3
@export var shotgun_aimRecoil : Vector3
@export var shotgun_zRecoil : float
@export var rifle_recoil : Vector3
@export var rifle_aimRecoil : Vector3
@export var rifle_zRecoil : float
var zRecoil: float
var recoil: Vector3
var aimRecoil: Vector3

@export_category("Settings")
## Rate at which the current rotation lerps to the target rotation
@export var snappiness : float
## Speed at which the weapon returns to its original position.
@export var returnSpeed : float

## Node containing "fire" signal and weapon logic
#@export var action_node: Node3D

func _ready() -> void:
	Globals.shotfired.connect(recoil_on_shotfired)
	
func _on_weapon_container_weapon_changed(Weapon_Name) -> void:
	weaponname = Weapon_Name

func _process(delta : float) -> void:
	# Lerp target rotation to (0,0,0) and lerp current rotation to target rotation
	targetRotation = lerp(targetRotation, Vector3.ZERO, returnSpeed * delta)
	currentRotation = lerp(currentRotation, targetRotation, snappiness * delta)
	
	rotation = currentRotation
	

		
	if recoil.z == 0 and aimRecoil.z == 0:
		global_rotation.z = 0

	
func recoil_on_shotfired() -> void:
	if weaponname == "SPS12":
		recoil = shotgun_recoil
		aimRecoil = shotgun_aimRecoil
		zRecoil = shotgun_zRecoil
#		print(weaponname)
		
	if weaponname == "PistolB":
		recoil = pistol_recoil
		aimRecoil = pistol_aimRecoil
		zRecoil = pistol_zRecoil
		
	if weaponname == "GRZA":
		recoil = rifle_recoil
		aimRecoil = rifle_aimRecoil
		zRecoil = rifle_zRecoil
#		print(weaponname)
		
	targetRotation += Vector3(recoil.x, randf_range(-recoil.y, recoil.y), randf_range(-recoil.z, recoil.z))
	
	rotation = targetRotation
	weapon_container.position.z += zRecoil
#	print(rotation)

func setRecoil(newRecoil : Vector3):
	"""
	Change recoil value.
	"""
	recoil = newRecoil
