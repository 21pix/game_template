extends Node
class_name NPCutilShootNPC

@onready var NPC: NPChuman = $"../.."
@onready var character_wpn: NPCweaponDesc = $"../CharacterWeapon"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var animation_tree: AnimationTree = $"../../AnimationTree2"
@onready var animTreePlayBack : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/StateMachine/playback")
@onready var npc_sound_player: AudioStreamPlayer3D = $"../../NPCSoundPlayer"
@onready var shoot_ray_npc: RayCast3D = $"../../ShootRayNPC"
@onready var detect_vision_npc: NPCutilDetectVisionNPC = $"../DetectVisionNPC"


func _ready() -> void:
	pass
	
func shoot_npc_sequence_standing():
	if NPC.enemy_npc:
		animation_tree.set("parameters/TimeScale/scale", NPC.shot_time)
		animTreePlayBack.travel("hmn_shoot_stand")
		npc_sound_player.play()
		NPC.character_wpn.emit_muzzle_flash()
		shoot_ray_npc.look_at(NPC.enemy_npc.position + Vector3(0, 1.5, 0), Vector3.UP)
		shoot_ray_npc.force_raycast_update()
		var Scollider = shoot_ray_npc.get_collider()
		if Scollider:
			if Scollider.is_in_group("Enemy_Hitbox"):
				shoot_ray_npc.debug_shape_custom_color = Color(255,0,0)
				Scollider.Enemy_Hit(character_wpn.char_wpn.damage*0.2)
				NPC.enemy_npc.detect_vision_npc.get_attacker_target(NPC) 
			else: return
		else: return
	else: return
		
func _loop_shoot_npc():
	if NPC.vsnpc_combat_state:
		if NPC.enemy_npc:
			if NPC.count < NPC.shot_count:
				NPC.count += 1
#				print("shots_count :", shot_count, "shots: ", count)
				shoot_npc_sequence_standing()
			else :
				NPC.shoot_done = true
		else: return
	else: return
