extends Node
class_name NPCutilDetectVision

@onready var NPC: NPChuman = $"../.."
@onready var NPC_vision_cone: Area3D = $"../../Armature/VisionCone"
@onready var NPC_vision_ray: RayCast3D = $"../../VisionRay"
@onready var detection_vision_tmr: Timer = $"../../TIMERS/DetectionVision_tmr"
@onready var distances: NPCutilDistances = $"../Distances"
@onready var player_friend: String = "PlayerFriend" + str(NPC.char_desc.enemy_suffix)
@onready var player_neutral: String = "PlayerNeutral" + str(NPC.char_desc.enemy_suffix)
@onready var player_enemy: String = "PlayerEnemy" + str(NPC.char_desc.enemy_suffix)

func _ready() -> void:
	detection_vision_tmr.start()

func _on_detection_vision_tmr_timeout() -> void:
	var overlaps = NPC_vision_cone.get_overlapping_bodies() #VISION TRIGGER
	if overlaps.size() > 0:
		for overlap in overlaps:
			# SEE ENEMY ----------------------------------------------------
			if overlap.is_in_group(player_enemy):
				NPC.enemy = overlap
				distances.start_dist_calc_delayed()
				var enemyPosition = overlap.global_transform.origin+Vector3(0,1,0)
				NPC_vision_ray.look_at(enemyPosition, Vector3.UP)
				NPC_vision_ray.force_raycast_update()
#				print(overlap)
				
				if NPC_vision_ray.is_colliding():
					var Vcollider = NPC_vision_ray.get_collider()
					if Vcollider.is_in_group(player_enemy):
						NPC_vision_ray.debug_shape_custom_color = Color(50,0,120)
#						var target_player_pos = Vcollider.global_transform.origin
						NPC.enemy_spotted = true
						
					else:
						NPC_vision_ray.debug_shape_custom_color = Color(0,255,0)
						NPC.enemy_spotted = false
				else:
					NPC_vision_ray.debug_shape_custom_color = Color(0,128,128)
					NPC.enemy_spotted = false
					
			elif overlap.is_in_group(player_neutral):
				NPC.friend_meet_spotted = false
				NPC.neutral_meet = overlap
				distances.start_dist_calc_delayed()
				var playerPosition = overlap.global_transform.origin+Vector3(0,1,0)
				NPC_vision_ray.look_at(playerPosition, Vector3.UP)
				NPC_vision_ray.force_raycast_update()
				
				if NPC_vision_ray.is_colliding() and NPC.meet_neutral_dist_on:
					var Vcollider = NPC_vision_ray.get_collider()
					if Vcollider.is_in_group(player_neutral):
						NPC_vision_ray.debug_shape_custom_color = Color(100,0,20)
#						var target_player_pos = Vcollider.global_transform.origin
						NPC.neutral_meet_spotted = true
					else :
						NPC.neutral_meet_spotted = false
				else :
					NPC.neutral_meet_spotted = false
			else:
				NPC_vision_ray.debug_shape_custom_color = Color(0,128,128)
				NPC.enemy_spotted = false
	else:
		NPC_vision_ray.debug_shape_custom_color = Color(0,128,128)
		NPC.enemy_spotted = false	
	trigger_conditions()
	
func trigger_conditions():
	if !NPC.enemy_detected and !NPC.enemy_spotted:
		NPC.enemy_lost = true

		
