extends Node3D

signal Weapon_Changed
signal Update_Ammo
signal Pickup_Ammo_P
signal Pickup_Ammo_R
signal Pickup_Ammo_S
signal Pickup_Ammo_M
signal Pickup_Ammo_X

signal Pickup_weapon

signal CurrentAmmo_P
signal CurrentAmmo_R
signal CurrentAmmo_S
signal CurrentAmmo_M
signal CurrentAmmo_X
signal shotfired
#---- weapon sounds preload
@onready var PistolShootSound = preload("res://assets/sounds/weapons/pistol.mp3")
@onready var ShotgunShootSound = preload("res://assets/sounds/weapons/ShotGun4.mp3")
@onready var RifleShootSound = preload("res://assets/sounds/weapons/RifleShot3.mp3")

@onready var crosshair: TextureRect = $"../../../HUD/Crosshair"
@onready var weapon_stream: AudioStreamPlayer = $"../../../PlayerAudio/WeaponStream"
@onready var interact_ray: RayCast3D = $"../InteractDetect/InteractRay"

@onready var head =$"../.."
@onready var camera =$".."
@onready var raycast =$"../RayCast"
@onready var muzzle =$"../Muzzle"
@onready var WeaponContainer = $"."
@onready var weaponslot: Node3D = $WeaponSlot

@onready var cooldown =$"../../../Cooldown"
@onready var reload_timer =$"../../../reload"
@onready var Bullet_Point = get_node("%Bullet_Point")
@onready var contplayer: AnimationPlayer = $"../../../ContPlayer"

@export var WeaponContainer_offset = Vector3(0.1, -0.12, 0)
@export_subgroup("Weapons")
var WeaponSet: Array[WeaponClass]
var WeaponList : Array

#@export var ArmsSet: Array[Arms] = []

@onready var pistol =load("res://Weapon_Resources/Pistol.tres")
@onready var shotgun =load("res://Weapon_Resources/Shotgun.tres")
@onready var rifle =load("res://Weapon_Resources/Rifle.tres")
@onready var pistolB =load("res://Weapon_Resources/Pistol.tres")
#@onready var shotgunB =load("res://weapons/shotgunB.tres")
#@onready var rifleB =load("res://weapons/rifleB.tres")
	
var ammo_P = 12
var ammo_R = 30
var ammo_S = 20
var ammo_M = 30
var ammo_X = 8

var WeaponShootSound
var targetFov
var tween:Tween
var tween_aimIn
var tween_aimOut
var tweenChange
var contPosOrigin
var weapon_index := 0
var Weapon_List = {}
var weapon: WeaponClass
var pu_weapon : pickup_weapon
var arm: Arms
var arm_index := 0
var can_shoot: bool = true
var interact: bool = false
var detectarea: bool = false
var shot_count: int = 0

func _ready():
	WeaponSet = [rifle]
	WeaponList = ["rifle"]
	weapon = WeaponSet[weapon_index] # Weapon must never be nil
	initiate_change_weapon(weapon_index)
	contplayer.play("ContIdle")
	Globals.connect("add_ammo_R", add_ammo_R)
	Globals.connect("add_ammo_S", add_ammo_S)
	Globals.connect("add_ammo_P", add_ammo_P)
	Globals.connect("add_pistol", add_pistol)
	Globals.connect("add_shotgun", add_shotgun)
	Globals.connect("add_rifle", add_rifle)
	
	
func initialize(_start_weapons: Array):
	for weapon in WeaponSet:
		Weapon_List[weapon.Weapon_Name] = weapon
		
func _physics_process(delta):

	handle_weapon(delta)

func handle_weapon(_delta):
	var type = weapon.Weapon_Type
	
	if Input.is_action_just_pressed("weapon_toggle_up"):
		action_weapon_toggle_up()
	
	if Input.is_action_just_pressed("weapon_toggle_down"):
		action_weapon_toggle_down()
		
	if Input.is_action_pressed("shoot"):
		shoot_main()
		
	if Input.is_action_just_released("shoot"):
		shot_count = 0
		
	if Input.is_action_just_pressed("AIM"):
		targetFov = camera.fov - 10	
		aimCam(targetFov)
		
	if Input.is_action_pressed("AIM"):
		aimWpn()
		
	if Input.is_action_just_released("AIM"):
		targetFov = camera.fov + 10	
		contPosOrigin = WeaponContainer.position
		aimCam_out(targetFov)
#		aimWpn_out()
		
	if Input.is_action_pressed("weapon_reload"):
		action_weapon_reload()
		
	if Input.is_action_pressed("select_pistol"):
		if "pistol" in WeaponList:
			weapon_index = 0
			weapon = WeaponSet[weapon_index] # Weapon must never be nil
			initiate_change_weapon(weapon_index)
			contplayer.play("ContIdle")
			
	if Input.is_action_pressed("select_shotgun"):
		if "shotgun" in WeaponList:
			weapon_index = 1
			weapon = WeaponSet[weapon_index] # Weapon must never be nil
			initiate_change_weapon(weapon_index)
			contplayer.play("ContIdle")
	
	if Input.is_action_pressed("select_rifle"):
		if "rifle" in WeaponList:
			weapon_index = 2
			weapon = WeaponSet[weapon_index] # Weapon must never be nil
			initiate_change_weapon(weapon_index)
			contplayer.play("ContIdle")
	else: return
	
func action_weapon_toggle_up():
	var Current_Weapon = weapon
	var type = weapon.Weapon_Type
	if type == "Pistol":	
		emit_signal("CurrentAmmo_P", weapon.Current_Ammo, ammo_P)	
	elif type == "Shotgun":	
		emit_signal("CurrentAmmo_S", weapon.Current_Ammo, ammo_S)	
	elif type == "Rifle":	
		emit_signal("CurrentAmmo_R", weapon.Current_Ammo, ammo_R)	
		
	weapon_index = wrap(weapon_index + 1, 0, WeaponSet.size())
	initiate_change_weapon(weapon_index)
	Audio.play("sounds/weapon_change.ogg")

# Initiates the weapon changing animation (tween)

func action_weapon_toggle_down():
	var Current_Weapon = weapon
	var type = weapon.Weapon_Type
	if type == "Pistol":	
		emit_signal("CurrentAmmo_P", weapon.Current_Ammo, ammo_P)	
	elif type == "Shotgun":	
		emit_signal("CurrentAmmo_S", weapon.Current_Ammo, ammo_S)	
	elif type == "Rifle":	
		emit_signal("CurrentAmmo_R", weapon.Current_Ammo, ammo_R)	
		
	weapon_index = wrap(weapon_index + 1, 0, WeaponSet.size())
	initiate_change_weapon(weapon_index)
	Audio.play("sounds/weapon_change.ogg")

# Initiates the weapon changing animation (tween)

func initiate_change_weapon(index):
	
	weapon_index = index

	var tweenChange = get_tree().create_tween()
	tweenChange.set_ease(Tween.EASE_OUT_IN)
	tweenChange.tween_property(WeaponContainer, "position", WeaponContainer_offset - Vector3(0, 1, 0), 0.1)
	tweenChange.tween_callback(change_weapon) # Changes the model
	
# Switches the weapon model (off-screen)

func change_weapon():
	
	weapon = WeaponSet[weapon_index]
	# Step 1. Remove previous weapon model(s) from container
	
	for n in weaponslot.get_children():
		weaponslot.remove_child(n)
	
	# Step 2. Place new weapon model in container
	
	var weapon_model = weapon.model.instantiate()
	weaponslot.add_child(weapon_model)

	
	weapon_model.position = weapon.position
	weapon_model.rotation_degrees = weapon.rotation
	
	# Step 3. Set model to only render on layer 2 (the weapon camera)
	
	for child in weapon_model.find_children("*", "MeshInstance3D"):
		child.layers = 2
			
	# Set weapon data
	
	raycast.target_position = Vector3(0, 0, -1) * weapon.max_distance
	
	var Current_Weapon = weapon
# HUD INFO 
	emit_signal("Weapon_Changed", Current_Weapon.Weapon_Name)
	emit_signal("Update_Ammo", Current_Weapon.Current_Ammo, Current_Weapon.Reserve_Ammo)

		
#-----------------------AIM
func aimCam(targetFov):
	var aimPos = weapon.aimPos
	var tween_aimCamIn = create_tween()
	tween_aimCamIn.set_ease(Tween.EASE_OUT_IN)
	tween_aimCamIn.tween_property(camera, "fov", targetFov, 0.2)

func aimWpn():
	crosshair.visible = false
	var aimPos = weapon.aimPos
	var tween_aimWpnIn = create_tween()
	tween_aimWpnIn.set_ease(Tween.EASE_OUT_IN)
	tween_aimWpnIn.tween_property(self, "position", aimPos , 0.2)
	tween_aimWpnIn.tween_property(self, "position", WeaponContainer.position , 0.10)
	
func aimCam_out(targetFov):	
	var tween_aimOut = create_tween()
	tween_aimOut.set_ease(Tween.EASE_OUT_IN)
	tween_aimOut.tween_property(camera, "fov", targetFov, 0.50)
	crosshair.visible = true

#-----------------------WEAPON SHOT DELAY
func _on_cooldown_timeout() -> void:
	can_shoot = true
	
#-----------------------SHOOTING WEAPONS 

func shoot_main():
	var type = weapon.Weapon_Type
	if type == "Pistol":	
		WeaponShootSound = PistolShootSound
	elif type == "Shotgun":	
		WeaponShootSound = ShotgunShootSound
	elif type == "Rifle":	
		WeaponShootSound = RifleShootSound
	if weapon.Current_Ammo > 0:
		if cooldown.is_stopped():
			if shot_count == weapon.shot_count: return
			shot_count += 1

			if !reload_timer.is_stopped(): return
			cooldown.start(weapon.cooldown)
			weapon.Current_Ammo -= 1
			emit_signal("CurrentAmmo_R", weapon.Current_Ammo, ammo_R)	
			weapon_stream.stream = WeaponShootSound
			weapon_stream.play()
			raycast.target_position.x = randf_range(-weapon.spread, weapon.spread)
			raycast.target_position.y = randf_range(-weapon.spread, weapon.spread)
			
			raycast.force_raycast_update()
			Globals.emit_signal("shotfired")
			if !raycast.is_colliding(): return # Don't create impact when raycast didn't hit
			collision_and_particles()
			_update_ammo_stats()

			
#			emit_signal("shotfired")
			
	else: action_weapon_reload()	

func _update_ammo_stats():
	var Current_Weapon = weapon
	var type = weapon.Weapon_Type
	if type == "Pistol":	
		emit_signal("CurrentAmmo_P", weapon.Current_Ammo, ammo_P)	
	elif type == "Shotgun":	
		emit_signal("CurrentAmmo_S", weapon.Current_Ammo, ammo_S)	
	elif type == "Rifle":	
		emit_signal("CurrentAmmo_R", weapon.Current_Ammo, ammo_R)	

	
func collision_and_particles():
# Sets Var Collider when Raycast hits an object using Collision + sends signal Hit
	var collider = raycast.get_collider()
	var col_Normal = raycast.get_collision_normal()
	var GunDamage = weapon.damage
				
# Defines collision point
	var Col_Point = raycast.get_collision_point() + (raycast.get_collision_normal() / 100)
	var Bullet_Direction = (Col_Point - Bullet_Point.get_global_transform().origin).normalized()	
	
# Applies damage to target using Enemy_Hit function or Target group
	if collider.has_method("Enemy_Hit"):
		collider.Enemy_Hit(weapon.damage) # Sends damage to function Enemy_Hit (Enemy script)
	if collider.has_method("_ApplyImpulse"):
		collider._ApplyImpulse(GunDamage, Bullet_Direction)


# Creating a dust animation
	if collider.is_in_group("Creature"):
		var impact_instance = Globals.bloodpart.instantiate()
		impact_instance.play("blood")
		get_tree().root.add_child(impact_instance)
		impact_instance.position = Col_Point
		impact_instance.look_at(camera.global_transform.origin, Vector3.UP, true) 
		
	if collider.is_in_group("Objects"):
		var impact_instance = Globals.impact.instantiate()
		impact_instance.play("sparks")
		get_tree().root.add_child(impact_instance)
		impact_instance.position = Col_Point
		impact_instance.look_at(camera.global_transform.origin, Vector3.UP, true) 
				
# Creating an impact decal
	if collider.is_in_group("Objects"):	
		var bhole_instance = Globals.BulletHoleD.instantiate()					
		get_tree().root.add_child(bhole_instance)
		bhole_instance.position = Col_Point
		bhole_instance.look_at(Col_Point + col_Normal, Vector3.DOWN)
		await get_tree().create_timer(10).timeout
		bhole_instance.queue_free()


	
	
# ----------------MAIN RELOAD 

func action_weapon_reload():
	var type = weapon.Weapon_Type
	
	if type == "Rifle":	
		action_weapon_reload_rifle()
		
	if type == "Pistol":	
		action_weapon_reload_pistol()
		
	if type == "Shotgun":	
		action_weapon_reload_shotgun()
		
	if type == "Plasma":	
				pass
	if type == "RPG":	
				pass
	
	
# RELOAD PISTOL
func action_weapon_reload_pistol():
	if weapon.Current_Ammo == weapon.Magazine:
		return
	if ammo_P > 0:
		if Input.is_action_pressed("weapon_reload"):
			reload_timer.start(weapon.reload_time)
			Audio.play("sounds/Weapons/Rifle_reload.mp3")
			Globals.reload.emit()
			
			var reload_amount = min(weapon.Magazine-weapon.Current_Ammo, weapon.Magazine, ammo_P)
			ammo_P = ammo_P - reload_amount
			weapon.Current_Ammo = weapon.Current_Ammo + reload_amount
			
			var ammo_current = weapon.Current_Ammo
			emit_signal("CurrentAmmo_P", ammo_current, ammo_P)		
			
	else: return
	
		
# RELOAD  RIFLE

func action_weapon_reload_rifle():
	if weapon.Current_Ammo == weapon.Magazine:
		return
	if ammo_R > 0:
		if Input.is_action_pressed("weapon_reload"):
			reload_timer.start(weapon.reload_time)
			Audio.play("sounds/Weapons/Rifle_reload.mp3")
			Globals.reload.emit()
			
			var reload_amount = min(weapon.Magazine-weapon.Current_Ammo, weapon.Magazine, ammo_R)
			ammo_R = ammo_R - reload_amount
			weapon.Current_Ammo = weapon.Current_Ammo + reload_amount
			
			var ammo_current = weapon.Current_Ammo
			emit_signal("CurrentAmmo_R", ammo_current, ammo_R)		
			
	else: return
	
# RELOAD  SHOTGUN

func action_weapon_reload_shotgun():
	if weapon.Current_Ammo == weapon.Magazine:
		return
	if ammo_S > 0:
		if Input.is_action_pressed("weapon_reload"):
			reload_timer.start(weapon.reload_time)
			Audio.play("sounds/GRZ_reload.ogg")
			Globals.reload.emit()
			
			var reload_amount = min(weapon.Magazine-weapon.Current_Ammo, weapon.Magazine, ammo_S)
			ammo_S = ammo_S - reload_amount
			weapon.Current_Ammo = weapon.Current_Ammo + reload_amount
			
			var ammo_current = weapon.Current_Ammo
			emit_signal("CurrentAmmo_S", ammo_current, ammo_S)		
			
	else: return
	
	
#AMMO pickup MAIN


		

#AMMO PICKUP DETAILS
func add_ammo_P() -> void:
	ammo_P = ammo_P + 12
	emit_signal("CurrentAmmo_P", weapon.Current_Ammo, ammo_P)

func add_ammo_S() -> void:
	ammo_S = ammo_S + 20
	emit_signal("CurrentAmmo_S", weapon.Current_Ammo, ammo_S)
	
func add_ammo_R() -> void:
#	print("ammo R received")
	ammo_R = ammo_R + 30
	emit_signal("CurrentAmmo_R", weapon.Current_Ammo, ammo_R)	
	

	
# WEAPON PICKUP

### WEAPONS ###
func add_pistol() -> void:

	if !"pistol" in WeaponList and !"pistolB" in WeaponList:
		WeaponSet.push_back(pistol)
		WeaponList.append("pistol")
		
		ammo_P += 10
		var ammo_current = weapon.Current_Ammo
		emit_signal("CurrentAmmo_P", ammo_current, ammo_P)
		
#		print(WeaponSet)
#		print(WeaponList)
	else:
		ammo_P += 10
		var ammo_current = weapon.Current_Ammo
		emit_signal("CurrentAmmo_P", ammo_current, ammo_P)
			
func add_pistolb() -> void:	

	if !"pistolB" in WeaponList and !"pistol" in WeaponList:
		WeaponSet.push_back(pistolB)
		WeaponList.append("pistolB")
		
		ammo_P += 10
		var ammo_current = weapon.Current_Ammo
		emit_signal("CurrentAmmo_P", ammo_current, ammo_P)
		
#		print(WeaponSet)
#		print(WeaponList)
	elif !"pistolB" in WeaponList and "pistol" in WeaponList:
		WeaponSet.erase(pistol)
		WeaponSet.push_back(pistolB)
		WeaponList.erase("pistol")
		WeaponList.append("pistolB")
		
		ammo_P += 10
		var ammo_current = weapon.Current_Ammo
		emit_signal("CurrentAmmo_P", ammo_current, ammo_P)
		
#		print(WeaponSet)
#		print(WeaponList)
	else:
		ammo_P += 10
		var ammo_current = weapon.Current_Ammo
		emit_signal("CurrentAmmo_P", ammo_current, ammo_P)

func add_shotgun() -> void:

	if !"shotgun" in WeaponList:
		WeaponSet.push_back(shotgun)
		WeaponList.append("shotgun")
		
		ammo_S += 10
		var ammo_current = weapon.Current_Ammo
		emit_signal("CurrentAmmo_S", ammo_current, ammo_S)
		
#		print(WeaponSet)
#		print(WeaponList)
	else:
		ammo_S += 10
		var ammo_current = weapon.Current_Ammo
		emit_signal("CurrentAmmo_S", ammo_current, ammo_S)

func add_rifle() -> void:
	if !"rifle" in WeaponList:
		WeaponSet.push_back(rifle)
		WeaponList.append("rifle")
			
		ammo_R += 10
		var ammo_current = weapon.Current_Ammo
		emit_signal("CurrentAmmo_R", ammo_current, ammo_R)
			
#		print(WeaponSet)
#		print(WeaponList)
	else:
		ammo_R += 10
		var ammo_current = weapon.Current_Ammo
		emit_signal("CurrentAmmo_R", ammo_current, ammo_R)
