extends Node
class_name NPCweaponDesc

@onready var NPC: NPChuman = $"../.."
@onready var char_wpn_list = []
@onready var weapon_slot: Node3D = $"../../Armature/Skeleton3D/BoneAttachment3D/WeaponSlot"
@onready var wpn_equiped
@onready var muz_equiped
@onready var char_wpn
@onready var wpn_max_shots: int
@onready var wpn_shot_time: int
@onready var wpn_sound: AudioStreamMP3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var weapon1 = NPC.char_desc.Weapon1
	char_wpn_list.append(weapon1)
	var weapon2 = NPC.char_desc.Weapon2
	char_wpn_list.append(weapon2)
	var weapon3 = NPC.char_desc.Weapon3
	char_wpn_list.append(weapon3)
	
	char_wpn = char_wpn_list.pick_random()
	wpn_max_shots = char_wpn.shot_count
	wpn_shot_time = char_wpn.shot_time
	wpn_sound = char_wpn.wpn_sound
	
	#equip weapon model
	wpn_equiped = char_wpn.wpn_model.instantiate()
	weapon_slot.add_child(wpn_equiped)
	wpn_equiped.position = char_wpn.wpn_position
	wpn_equiped.rotation_degrees = char_wpn.wpn_rotation
	
	#equip muzzle flash
	muz_equiped = char_wpn.muz_model.instantiate()
	weapon_slot.add_child(muz_equiped)
	muz_equiped.position = char_wpn.muz_position
	muz_equiped.rotation_degrees = char_wpn.muz_rotation
	
func emit_muzzle_flash():
	muz_equiped.npc_muzzle_flash()
