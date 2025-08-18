extends Node
class_name NPCutilShootPlayer

@onready var NPC: NPChuman = $"../.."
@onready var character_wpn: NPCweaponDesc = $"../CharacterWeapon"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var animation_tree: AnimationTree = $"../../AnimationTree2"
@onready var animTreePlayBack : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/StateMachine/playback")
@onready var animTreePlayBackAttackCrouch : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/StateMachine/ATTACK_CROUCH/playback")
@onready var npc_sound_player: AudioStreamPlayer3D = $"../../NPCSoundPlayer"
@onready var shoot_ray: RayCast3D = $"../../ShootRay"
@onready var bullet_point: Marker3D = $"../../BulletPoint"
@export var damage_multiplier: float

func shoot_sequence_standing():
	animation_tree.set("parameters/TimeScale/scale", NPC.shot_time)
	animTreePlayBack.travel("hmn_shoot_stand")
	NPC.NPCshoot.emit()
	npc_sound_player.play()
	character_wpn.emit_muzzle_flash()
	shoot_ray.look_at(NPC.player.position + Vector3(0, 0.5, 0), Vector3.UP)
#	shoot_ray.target_position.x = randf_range(-2, 2)
#	shoot_ray.target_position.y = randf_range(-2, 2)
	shoot_ray.force_raycast_update()
				
	shoot_ray.debug_shape_custom_color = Color(0,128,128)
	var Scollider = shoot_ray.get_collider()
	if Scollider == NPC.player:
#		shoot_ray.debug_shape_custom_color = Color(255,0,0)
#		if player.has_method("damage"):
			NPC.player.hit()
			NPC.player.damage(character_wpn.char_wpn.damage*damage_multiplier)	
	collision_and_particles()
	
func collision_and_particles():
# Sets Var Collider when Raycast hits an object using Collision + sends signal Hit
	var Scollider = shoot_ray.get_collider()
	var col_Normal = shoot_ray.get_collision_normal()
				
# Defines collision point
	var Col_Point = shoot_ray.get_collision_point() + (shoot_ray.get_collision_normal() / 100)
	var Bullet_Direction = (Col_Point - bullet_point.get_global_transform().origin).normalized()
	if Scollider.is_in_group("Objects"):

		var bhole_instance = Globals.BulletHoleD.instantiate()
		get_tree().root.add_child(bhole_instance)
		bhole_instance.position = Col_Point
		bhole_instance.look_at(Col_Point + col_Normal, Vector3.DOWN)
		await get_tree().create_timer(10).timeout
		bhole_instance.queue_free()
		
func _loop_shoot():
	if NPC.attack_state:
		if NPC.count < NPC.shot_count:
			NPC.count += 1
#			print("shots_count :", shot_count, "shots: ", count)
			shoot_sequence_standing()
		else :
			NPC.shoot_done = true
	else: return

func shoot_sequence_crouch():

	animation_tree.set("parameters/TimeScale/scale", NPC.shot_time)
	animTreePlayBack.travel("ATTACK_CROUCH")
	animTreePlayBackAttackCrouch.travel("hmn_shoot_crouch")
	NPC.NPCshoot.emit()
	npc_sound_player.play()
	shoot_ray.look_at(NPC.player.position + Vector3(0, 0.5, 0), Vector3.UP)
#	shoot_ray.target_position.x = randf_range(-2, 2)
#	shoot_ray.target_position.y = randf_range(-2, 2)
	shoot_ray.force_raycast_update()
				
	shoot_ray.debug_shape_custom_color = Color(0,128,128)
	var Scollider = shoot_ray.get_collider()
	if Scollider == NPC.player:
		shoot_ray.debug_shape_custom_color = Color(255,0,0)
		if NPC.player.has_method("damage"):
			NPC.player.hit()
			NPC.player.damage(0.5)	
	else :
		shoot_ray.debug_shape_custom_color = Color(0,0,128)
		
func _loop_shoot_crouch():
	if NPC.attack_state:
		if NPC.count < NPC.shot_count:
			NPC.count += 1
#			print("shots_count :", shot_count, "shots: ", count)
			shoot_sequence_crouch()
		else :
			NPC.shoot_done = true
	else: return
