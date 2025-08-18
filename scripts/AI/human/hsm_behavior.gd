extends Node
class_name NPCMainStateMachine

@onready var NPC = $".."
@onready var Cover: CoverDetect = $"../Dependencies/Cover"
@onready var closest_object: ClosestObject = $"../Dependencies/ClosestObject"
@onready var distances: NPCutilDistances = $"../Dependencies/Distances"
@onready var distances_npc: NPCutilDistancesNPC = $"../Dependencies/DistancesNPC"
@onready var shoot_npc: NPCutilShootNPC = $"../Dependencies/ShootNPC"
@onready var shoot_player: NPCutilShootPlayer = $"../Dependencies/ShootPlayer"
@onready var detect_vision_npc: NPCutilDetectVisionNPC = $"../Dependencies/DetectVisionNPC"
@onready var navigation_agent_3d: NavigationAgent3D = $"../NavigationAgent3D"


#=============================================================================
# NEUTRAL STATE JOBS SETUP
#===============================================
func set_patrol_on(patrol): #THIS FUNC IS CALLED FROM LOGIC NODE - RECIEVES PATROL POINTS THROUGH "patrol" argument
	if NPC.neutral_state:
		NPC.patrol_scheme = true
		NPC.patrolPointList = patrol
		$StateChart.send_event("to_patrol")
	else :
		return

func set_guard_on(guard): #THIS FUNC IS CALLED FROM LOGIC NODE
	if NPC.neutral_state:
		NPC.guard_scheme = true
		NPC.guardPointList = guard
		$StateChart.send_event("to_guard")
	else :
		return
		
func start_camp_scheme(): #THIS FUNC IS CALLED FROM CAMP MAIN NODE
	if NPC.neutral_state:
		NPC.camp_scheme = true
		NPC.camp_main_target_set = false
		$StateChart.send_event("to_guard")
	else :
		return
		
func set_sit_on(sit): #THIS FUNC IS CALLED FROM CAMP MAIN NODE
	if NPC.neutral_state:
		NPC.sit_scheme = true
		NPC.sitPointList = sit
		$StateChart.send_event("to_sit_camp")
	else :
		return

#*******************************************************************************
#                               MAIN STATE MACHINE
#*******************************************************************************

#/////////////////////////////// NEUTRAL MAIN /////////////////////////////////
func _on_neutral_state_entered() -> void:
	NPC.neutral_state = true
	if !NPC.meet_state:
		distances.stop_dist_calc()
	distances_npc.vsnpc_distances_tmr.stop()
	distances_npc.stop_dist_calc_npc()
	NPC.enemy = null
	NPC.enemy_npc = null
	
func _on_neutral_state_physics_processing(_delta: float) -> void:
	
	if NPC.meet_neutral_dist_on:
		$StateChart.send_event("neutral_to_meet_neutral")
		
	if NPC.enemy_spotted:
		$StateChart.send_event("neutral_to_hostile")
		
	if NPC.enemy_detected:
		$StateChart.send_event("neutral_to_hostile")
		
	if NPC.enemy_npc_spotted:
		$StateChart.send_event("to_vsnpccombat")
		
	if NPC.alert_state:
		var anim = "hmn_stand_idle_aim"
		var target_look = NPC.enemy.global_position
		NPC.stand_idle_hostile(anim, target_look)
		
	if NPC.npc_dead:
		$StateChart.send_event("neutral_to_death")

func _on_neutral_state_exited() -> void:
	NPC.neutral_state = false
	NPC.camp_scheme = false
	NPC.camp_main_list_set = false
	
	if !NPC.meet_friend_dist_on:
		NPC.guard_scheme = false
	
#=============================== NEUTRAL SELECTOR

func _on_selector_state_entered() -> void:
	NPC.campMainList = get_tree().get_nodes_in_group("camp_main")
	await get_tree().create_timer(1.0).timeout	
	select_scheme()

func select_scheme():

	if !NPC.enemy_detected:
	
		if !NPC.patrol_scheme and !NPC.guard_scheme and !NPC.camp_scheme:
			$StateChart.send_event("to_travel")
			
#/////////////////////////////// TRAVEL MAIN ///////////////////////////////////

func _on_travel_state_entered() -> void:
	pass

func _on_travel_state_physics_processing(_delta: float) -> void:
	if !NPC.meet_friend_dist_on:
		$StateChart.send_event("to_move_to_travel_target")
		
	if NPC.camp_main_list_set:
			$StateChart.send_event("to_move_to_travel_target")
		
	if NPC.patrol_scheme:
			$StateChart.send_event("to_patrol")
		
	if NPC.guard_scheme:
			$StateChart.send_event("to_guard")
		
	if NPC.camp_scheme:
			$StateChart.send_event("to_camp")
		
	if NPC.meet_friend_dist_on:
		$StateChart.send_event("to_meet_friend")
#============================== SET TRAVEL TARGET

func _on_select_travel_target_state_entered() -> void:
#	NPC.campTarget = null
	NPC.campMainList = get_tree().get_nodes_in_group("camp_main")
	NPC.camp_main_list_set = true
	
#============================== MOVE TO TRAVEL TARGET

func _on_move_to_travel_target_state_entered() -> void:
	print(NPC.campMainList)
	print(NPC.campTarget)
	
	if NPC.campTarget == null:
		closest_object.get_closest_object(NPC.campMainList)
		NPC.campTarget = NPC.minDistanceObject
	#NPC.camp_main_target_set = true
	
	NPC.navigation_agent.target_position = NPC.campTarget.position
	
func _on_move_to_travel_target_state_physics_processing(delta: float) -> void:
	var state = "NEUTRAL"
	var anim = "hmn_walk_fwd"
	NPC.move_to_target_anim(state, anim)	
	
	var look_at = Vector3(NPC.global_position.x + NPC.velocity.x, NPC.global_position.y, NPC.global_position.z + NPC.velocity.z)
	NPC.move_to_target(NPC.travel_target_dist, NPC.walk_speed, NPC.accel*delta, look_at)

#/////////////////////////////// GUARD MAIN ///////////////////////////////////

func _on_guard_state_entered() -> void:
	NPC.guard_scheme = true

func _on_guard_state_physics_processing(_delta: float) -> void:
	if !NPC.meet_friend_dist_on:
		if NPC.reached_guard_spot:
			$StateChart.send_event("to_guard_post_observe")
		if !NPC.reached_guard_spot:
			$StateChart.send_event("to_go_to_guard_spot")
	if NPC.meet_friend_dist_on:
		$StateChart.send_event("to_meet_friend")
		
func _on_guard_state_exited() -> void:
	NPC.guard_scheme = false
	NPC.reached_guard_spot = false
	
#============================== GO TO GUARD POST

func _on_go_to_guard_post_state_entered() -> void:
	await get_tree().create_timer(0.5).timeout
	var target_guard = NPC.guardPointList
	var target = target_guard.global_position
	NPC.navigation_agent.target_position = target
	
func _on_go_to_guard_post_state_physics_processing(delta: float) -> void:
	var state = "NEUTRAL"
	var anim = "hmn_walk_fwd"
	NPC.move_to_target_anim(state, anim)	
	
	var look_at = Vector3(NPC.global_position.x + NPC.velocity.x, NPC.global_position.y, NPC.global_position.z + NPC.velocity.z)
	NPC.move_to_target(NPC.guard_target_dist, NPC.walk_speed, NPC.accel*delta, look_at)
	if NPC.navigation_agent.is_navigation_finished():
		NPC.reached_guard_spot = true
		
#==== MEET FRIEND GUARD
func _on_meet_friend_guard_state_entered() -> void:
	GlobalsNpc.dialogue_enabled = true
	NPC.add_to_group("NPC_talking")


func _on_meet_friend_guard_state_physics_processing(delta: float) -> void:
	var anim = "hmn_stand_idle_neutral"
	var target_look = NPC.player.position
	NPC.stand_idle(anim, target_look)

func _on_meet_friend_guard_state_exited() -> void:
	GlobalsNpc.dialogue_enabled = false
	NPC.remove_from_group("NPC_talking")
		
#============================== GUARD POST OBSERVE

func _on_guard_post_observe_state_entered() -> void:
	pass # Replace with function body.

func _on_guard_post_observe_state_physics_processing(_delta: float) -> void:
	var target_look = NPC.global_position - NPC.navigation_agent.target_position
	var anim ="hmn_stand_idle_neutral"
	NPC.stand_idle(anim, target_look)
	
#/////////////////////////////// PATROL MAIN ///////////////////////////////////

func _on_patrol_state_entered() -> void:
	pass # Replace with function body.


func _on_patrol_state_physics_processing(_delta: float) -> void:
	if !NPC.meet_friend_dist_on:	
		if NPC.reached_patrol_spot:
			$StateChart.send_event("to_post_observe")
		
		if !NPC.reached_patrol_spot:
			$StateChart.send_event("to_move_to_first_post")
			
		if NPC.patrol_observe_done:
			if NPC.patrol_index < NPC.patrolPointList.size():
				$StateChart.send_event("to_move_to_next_post")
			if NPC.patrol_index == NPC.patrolPointList.size():
				$StateChart.send_event("to_move_to_first_post")
	
	if NPC.meet_friend_dist_on:
		$StateChart.send_event("to_meet_friend_patrol")
		
func _on_patrol_state_exited() -> void:
	NPC.patrol_scheme = false

#============================== MOVE TO FIRST POST

func _on_move_to_first_post_state_entered() -> void:
	NPC.reached_patrol_spot = false
	set_first_spot_target()
		
func set_first_spot_target():
	NPC.patrol_index = 0
	var patrol_point1 = NPC.patrolPointList[NPC.patrol_index]
	NPC.navigation_agent.target_position = Vector3(patrol_point1.global_position)

func _on_move_to_first_post_state_physics_processing(delta: float) -> void:
	var state = "NEUTRAL"
	var anim = "hmn_walk_fwd"
	NPC.move_to_target_anim(state, anim)	
	
	var look_at = Vector3(NPC.global_position.x + NPC.velocity.x, NPC.global_position.y, NPC.global_position.z + NPC.velocity.z)
	NPC.move_to_target(NPC.guard_target_dist, NPC.walk_speed, NPC.accel*delta, look_at)
	if NPC.navigation_agent.is_navigation_finished():
		NPC.reached_patrol_spot = true

func _on_move_to_first_post_state_exited() -> void:
	NPC.patrol_index += 1

#============================== POST OBSERVE STANDING

func _on_post_observe_standing_state_entered() -> void:
	NPC.patrol_observe_done = false	
	NPC.patrol_observe_tmr.start(5.0)

func _on_post_observe_standing_state_physics_processing(_delta: float) -> void:
	var target_look = NPC.global_position - NPC.navigation_agent.target_position
	var anim ="hmn_stand_idle_neutral"
	NPC.stand_idle(anim, target_look)

func _on_patrol_observe_tmr_timeout() -> void:
	NPC.patrol_observe_done = true
	
#============================== MOVE TO NEXT POST

func _on_move_to_next_post_state_entered() -> void:
	NPC.reached_patrol_spot = false
	set_target_patrol_point_2()
		
func set_target_patrol_point_2():
	var patrol_point2 = NPC.patrolPointList[NPC.patrol_index]
	NPC.navigation_agent.target_position = Vector3(patrol_point2.global_position)

func _on_move_to_next_post_state_physics_processing(delta: float) -> void:
	var state = "NEUTRAL"
	var anim = "hmn_walk_fwd"
	NPC.move_to_target_anim(state, anim)
	
	var look_at = Vector3(NPC.global_position.x + NPC.velocity.x, NPC.global_position.y, NPC.global_position.z + NPC.velocity.z)
	NPC.move_to_target(NPC.guard_target_dist, NPC.walk_speed, NPC.accel*delta, look_at)
	if NPC.navigation_agent.is_navigation_finished():
		NPC.reached_patrol_spot = true

func _on_move_to_next_post_state_exited() -> void:
	NPC.patrol_index += 1

#==== MEET FRIEND PATROL

func _on_meet_friend_patrol_state_entered() -> void:
	GlobalsNpc.dialogue_enabled = true
	NPC.add_to_group("NPC_talking")


func _on_meet_friend_patrol_state_physics_processing(delta: float) -> void:
	var anim = "hmn_stand_idle_neutral"
	var target_look = NPC.player.position
	NPC.stand_idle(anim, target_look)


func _on_meet_friend_patrol_state_exited() -> void:
	GlobalsNpc.dialogue_enabled = false
	NPC.remove_from_group("NPC_talking")
	
#/////////////////////////////// CAMP MAIN ///////////////////////////////////

func _on_camp_state_entered() -> void:
	pass # Replace with function body.

func _on_camp_state_physics_processing(_delta: float) -> void:
	pass # Replace with function body.

func _on_camp_state_exited() -> void:
	NPC.camp_scheme = false
	NPC.reached_main_camp = false
	NPC.sit_scheme = false
	NPC.sit_spot_target_acquired= false
	NPC.reached_sit_spot= false
	NPC.trans_stand_to_sit= false
	
#============================== TASK SELECTOR

func _on_task_selector_state_entered() -> void:
	NPC.camp_enter.start_random()

func _on_task_selector_state_physics_processing(_delta: float) -> void:
	var target_look = NPC.campTarget.position
	var anim = "hmn_stand_idle_neutral"
	NPC.stand_idle(anim, target_look)	
		
func _on_camp_enter_timeout() -> void:
	if NPC.sit_scheme:
		$StateChart.send_event("to_sit_camp")
		
	if !NPC.sit_scheme:
		$StateChart.send_event("to_stand_idle_camp")
	else: return
#============================== MAIN SIT STATE =================================

func _on_sit_state_entered() -> void:
	pass # Replace with function body.

func _on_sit_state_physics_processing(_delta: float) -> void:
	if NPC.sit_spot_target_acquired:
		$StateChart.send_event("to_move_to_sit_spot")
		
	if NPC.reached_sit_spot:
		$StateChart.send_event("to_trans_stand_to_sit")
	
	if !NPC.meet_friend_dist_on:	
		if NPC.trans_stand_to_sit:
			$StateChart.send_event("to_sit_idle")
	
	if NPC.meet_friend_dist_on:
		$StateChart.send_event("to_meet_friend_camp_sit")
		
func _on_sit_state_exited() -> void:
	pass # Replace with function body.

#============================== MOVE TO SIT SPOT

func _on_move_to_sit_spot_state_entered() -> void:
	var target = NPC.sitPointList.global_position
	NPC.navigation_agent.target_position = target
	
func _on_move_to_sit_spot_state_physics_processing(delta: float) -> void:
	var state = "NEUTRAL"
	var anim = "hmn_walk_fwd"
	NPC.move_to_target_anim(state, anim)
	
	var look_at = Vector3(NPC.global_position.x + NPC.velocity.x, NPC.global_position.y, NPC.global_position.z + NPC.velocity.z)
	NPC.move_to_target(NPC.sit_target_dist, NPC.walk_speed, NPC.accel*delta, look_at)	
	if NPC.navigation_agent.is_navigation_finished():
		NPC.reached_sit_spot = true

#============================== STAND TO SIT

func _on_trans_stand_to_sit_state_entered() -> void:
	NPC.stand_to_sit_low()
# Transition disabled because of SIT IDLE state not working

func transition_stand_to_sit_low_done(): # Transition disabled because of SIT IDLE state not working
#	trans_stand_to_sit = true
	pass
	
#============================== SIT IDLE
# State disabled because of sit anim not working properly
func _on_sit_idle_state_entered() -> void:
	pass # Replace with function body.

func _on_sit_idle_state_physics_processing(_delta: float) -> void:
	var anim = "hmn_sit_low_idle"
	var target_look = NPC.campTarget.position
	NPC.stand_idle(anim, target_look)

#==== MEET CAMP SIT
func _on_meet_friend_camp_sit_state_entered() -> void:
	GlobalsNpc.dialogue_enabled = true
	NPC.add_to_group("NPC_talking")

func _on_meet_friend_camp_sit_state_physics_processing(delta: float) -> void:
	pass # Replace with function body.

func _on_meet_friend_camp_sit_state_exited() -> void:
	GlobalsNpc.dialogue_enabled = false
	NPC.remove_from_group("NPC_talking")
	
#============================== STAND IDLE MAIN STATE ==========================

func _on_stand_idle_camp_state_entered() -> void:
	pass # Replace with function body.

func _on_stand_idle_camp_state_physics_processing(_delta: float) -> void:
	
	if !NPC.meet_friend_dist_on:
		if NPC.reached_idle_spot:
			$StateChart.send_event("to_stand_idle")
		if !NPC.reached_idle_spot:
			$StateChart.send_event("to_move_to_idle_spot")
					
	if NPC.meet_friend_dist_on:
		$StateChart.send_event("to_meet_friend_stand")
		
func _on_stand_idle_camp_state_exited() -> void:
	pass # Replace with function body.

#============================== MOVE TO IDLE SPOT

func _on_move_to_idle_spot_state_entered() -> void:
	NPC.set_target_idle_spot()

func _on_move_to_idle_spot_state_physics_processing(delta: float) -> void:
	var state = "NEUTRAL"
	var anim = "hmn_walk_fwd"
	NPC.move_to_target_anim(state, anim)
	
	var look_at = Vector3(NPC.global_position.x + NPC.velocity.x, NPC.global_position.y, NPC.global_position.z + NPC.velocity.z)
	NPC.move_to_target(NPC.stand_target_dist, NPC.walk_speed, NPC.accel*delta, look_at)	
	if NPC.navigation_agent.is_navigation_finished():
		NPC.reached_idle_spot = true

#============================== STAND IDLE SPOT

func _on_stand_idle_state_entered() -> void:
	pass # Replace with function body.
	
func _on_stand_idle_state_physics_processing(_delta: float) -> void:
	var anim = "hmn_stand_idle_neutral"
	var target_look = NPC.campTarget.position
	NPC.stand_idle(anim, target_look)

#==== MEET CAMP STAND
func _on_meet_friend_camp_stand_state_entered() -> void:
	GlobalsNpc.dialogue_enabled = true
	NPC.add_to_group("NPC_talking")


func _on_meet_friend_camp_stand_state_physics_processing(delta: float) -> void:
	var anim = "hmn_stand_idle_neutral"
	var target_look = NPC.player.position
	NPC.stand_idle(anim, target_look)


func _on_meet_friend_camp_stand_state_exited() -> void:
	GlobalsNpc.dialogue_enabled = false
	NPC.remove_from_group("NPC_talking")

#/////////////////////////////// HOSTILE MAIN ///////////////////////////////////

func _on_hostile_state_entered() -> void:

	NPC.hostile_state = true
	NPC.enemy_lost = false
	
func _on_hostile_state_physics_processing(_delta: float) -> void:
	
	if NPC.enemy_spotted and NPC.attack_dist_on:
		$StateChart.send_event("hostile_to_attack")
		
	if NPC.enemy_lost and NPC.enemy_search_fail:
		$StateChart.send_event("hostile_to_neutral")
		
	if NPC.npc_dead:
		$StateChart.send_event("hostile_to_death")
		
func _on_hostile_state_exited() -> void:
	NPC.hostile_state = false
	NPC.alert_state = false
	NPC.enemy_search_fail = false
#============================== HOSTILE LOOK FOR

func _on_look_for_state_entered() -> void:
	NPC.look_for_tmr.start(20.0)
	set_target_hostile_look_for()
	
func set_target_hostile_look_for():
	var target_hostile_look = NPC.player.position
	var target_hostile_look_adjusted := NavigationServer3D.map_get_closest_point(NPC.map, target_hostile_look)
	NPC.navigation_agent.target_position = target_hostile_look_adjusted
	
func _on_look_for_state_physics_processing(delta: float) -> void:
	var state = "HOSTILE"
	var anim = "hmn_walk_fwd_aim"
	NPC.move_to_target_hostile_anim(state, anim)
	
	var look_at = Vector3(NPC.global_position.x + NPC.velocity.x, NPC.global_position.y, NPC.global_position.z + NPC.velocity.z)
	NPC.move_to_target_hostile(NPC.guard_target_dist, NPC.look_for_speed, NPC.accel*delta, look_at)	
	if NPC.navigation_agent.is_navigation_finished() and NPC.enemy_spotted:
		print("reached target")
		set_target_hostile_look_for()
	if NPC.navigation_agent.is_navigation_finished() and !NPC.enemy_spotted:
		$StateChart.send_event("to_look_for_static")
		
			
func _on_look_for_tmr_timeout() -> void:
	if NPC.hostile_state:
		NPC.enemy_search_fail = true
	else: return
	
func _on_look_for_state_exited() -> void:
	pass # Replace with function body.

#============================== HOSTILE LOOK FOR STATIC

func _on_look_for_static_state_entered() -> void:
	pass # Replace with function body.

func _on_look_for_static_state_physics_processing(_delta: float) -> void:
	NPC.look_at(NPC.enemy.position)
	NPC.rotation_degrees.x=0
	NPC.rotation_degrees.z=0
	NPC.animTreePlayBack.travel("HOSTILE")
	NPC.animTreePlayBackHostile.travel("hmn_stand_idle_aim")

func _on_look_for_static_state_exited() -> void:
	pass # Replace with function body.
	
#============================== HOSTILE MOVE TO

func _on_move_to_state_entered() -> void:
	NPC.move_to_enemy_tmr.start(20.0)
	set_target_hostile_move_to()

func set_target_hostile_move_to():
	NPC.navigation_agent.target_position = NPC.enemy.position
	
func _on_move_to_state_physics_processing(delta: float) -> void:
	var state = "HOSTILE"
	var anim = "hmn_walk_fwd_aim"
	NPC.move_to_target_hostile_anim(state, anim)
	
	var look_at = Vector3(NPC.global_position.x + NPC.velocity.x, NPC.global_position.y, NPC.global_position.z + NPC.velocity.z)
	NPC.move_to_target_hostile(NPC.travel_target_dist, NPC.look_for_speed, NPC.accel*delta, look_at)	

	if NPC.navigation_agent.is_navigation_finished():
		print("reached target")
		set_target_hostile_move_to()
		
func _on_move_to_state_exited() -> void:
	pass # Replace with function body.
	
func _on_move_to_enemy_tmr_timeout() -> void:
	if NPC.hostile_state:
		NPC.enemy_lost = true
	else: return
	
#/////////////////////////////// ATTACK MAIN ///////////////////////////////////

func _on_attack_state_entered() -> void:
	NPC.cond_attack_main_tmr.start()
	NPC.npc_count_tmr.start()
	NPC.enemy_spotter_tmr_on = false
	NPC.attack_state = true

func _on_attack_state_physics_processing(_delta: float) -> void:
	pass
		
func _on_enemy_spotted_tmr_timeout() -> void:
	if !NPC.cover_scheme:
		$StateChart.send_event("attack_to_hostile")
		
func _on_attack_state_exited() -> void:
	NPC.attack_state = false
	NPC.enemy_spotter_tmr_on = false
	
func _on_npc_count_tmr_timeout() -> void:
	NPC.get_active_NPC()
	NPC.get_cover_list_alt()
#	print("NPC count: ", NPC.NPC_List.size())

func _on_cond_attack_main_tmr_timeout() -> void:
	if NPC.cover_defense_on and NPC.cover_available and NPC.cover_list.size() > 0:
#		print("cover atk on")
		$StateChart.send_event("to_cover_attack")	
		
	if NPC.cover_defense_on and NPC.cover_list.size() == 0:
		$StateChart.send_event("to_crouch_attack")
		
	if !NPC.enemy_spotted and !NPC.enemy_spotter_tmr_on:
		NPC.enemy_spotted_tmr.start(5.0)
		NPC.enemy_spotter_tmr_on = true
	
	if NPC.melee_attack_on:
		$StateChart.send_event("to_melee_attack")
		
	if NPC.npc_dead:
		$StateChart.send_event("attack_to_death")
		
	if !NPC.attack_dist_on:
		$StateChart.send_event("attack_to_hostile")
		
#============================== ATTACK SELECTOR

func _on_attack_selector_state_entered() -> void:
	NPC.attack_state_select1 = [1, 2].pick_random()
	NPC.attack_state_select2 = NPC.attack_states_list2.pick_random()
	NPC.attack_state_select3 = NPC.attack_states_list3.pick_random()
	NPC.attack_state_select4 = NPC.attack_states_list4.pick_random()
	
func _on_attack_selector_state_physics_processing(_delta: float) -> void:
	# DEBUG ONLY
	@warning_ignore("unused_variable")
	var debug_state = "to_flank_attack"
	#
	#--------- INTERIOR COMBAT
	if NPC.interior_restrictor_on :
		$StateChart.send_event("to_interior_attack")
		
	#--------- EXTERIOR COMBAT
	if !NPC.interior_restrictor_on:
		if NPC.NPC_List.size() == 1:
			if NPC.attack_state_select1 == 1:
				$StateChart.send_event("to_forward_attack") #forward_a
			if NPC.attack_state_select1 == 2:
				$StateChart.send_event("to_forward_alt_attack") #forward_alt_a
			
		if NPC.NPC_List.size() == 2:
			if NPC.attack_state_select2 == 1:
				$StateChart.send_event("to_forward_attack") #forward_a
			if NPC.attack_state_select1 == 2:
				$StateChart.send_event("to_forward_alt_attack") #forward_alt_a
			if NPC.attack_state_select2 == 3:
				$StateChart.send_event("to_far_attack") #far_a
			
		if NPC.NPC_List.size() == 3:
			if NPC.attack_state_select3 == 1:
				$StateChart.send_event("to_forward_attack")#forward_a
			if NPC.attack_state_select1 == 2:
				$StateChart.send_event("to_forward_alt_attack") #forward_alt_a
			if NPC.attack_state_select3 == 3:
				$StateChart.send_event("to_far_attack")#far_a
			if NPC.attack_state_select3 == 4:
				$StateChart.send_event("to_flank_attack")#flank_a
			
		if NPC.NPC_List.size() >= 4:
			if NPC.attack_state_select4 == 1:
				$StateChart.send_event("to_forward_attack")#forward_a
			if NPC.attack_state_select1 == 2:
				$StateChart.send_event("to_forward_alt_attack") #forward_alt_a
			if NPC.attack_state_select4 == 3:
				$StateChart.send_event("to_far_attack")#far_a
			if NPC.attack_state_select4 == 4:
				$StateChart.send_event("to_flank_attack")#flank_a
			if NPC.attack_state_select4 == 5:
				$StateChart.send_event("to_crouch_attack")#crouch_a
			
func _on_attack_selector_state_exited() -> void:
	pass # Replace with function body.

#///////////////////////////////////////////////////////////////////////////////
#/////////////////////////////// TEST ATTACK STATE /////////////////////////////

#============= MAIN TEST ATTACK STATE ==========================================
func _on_test_attack_state_entered() -> void:
	pass # Replace with function body.

func _on_test_attack_state_physics_processing(_delta: float) -> void:
		if NPC.move_closer_range:
			$StateChart.send_event("_to_test_move_closer")
		if NPC.min_circle_dist:
			$StateChart.send_event("_to_test_main_m1")

func _on_test_attack_state_exited() -> void:
	pass # Replace with function body.

#---- ATTACK TEST MOVE CLOSER

func _on_test_move_closer_state_entered() -> void:
	test_move_closer_set_target()

func test_move_closer_set_target():
	var closer_target = Vector3((NPC.global_position.x + NPC.enemy.global_position.x)/2, (NPC.global_position.y + NPC.enemy.global_position.y)/2, (NPC.global_position.z + NPC.enemy.global_position.z)/2)	
	var closer_target_adjusted := NavigationServer3D.map_get_closest_point(NPC.map, closer_target)
	NPC.navigation_agent.target_position = closer_target_adjusted

func _on_test_move_closer_state_physics_processing(delta: float) -> void:
	var state = "ATTACK_STAND"
	var anim = "hmn_run_fwd_aim"
	NPC.move_to_target_attack_anim(state, anim)
	
	var look_at = NPC.enemy.position
	NPC.move_to_target_attack(NPC.travel_target_dist, NPC.move_closer_speed, NPC.accel*delta, look_at)	
	if NPC.navigation_agent.is_navigation_finished():
		test_move_closer_set_target()

func _on_test_move_closer_state_exited() -> void:
	pass # Replace with function body.

#---- ATTACK TEST MOVE 1 ----------------------

func _on_test_main_move_1_state_entered() -> void:

	set_test_main_move_target()
	
func set_test_main_move_target():
	var x_offset = randf_range(2.0, 4.0)
	NPC.position_direction = [-1.0, 1.0].pick_random()
	var position_offset = (NPC.transform.basis.x*x_offset)*NPC.position_direction
	var move1_target = NPC.position + position_offset
	var move1_target_adjusted := NavigationServer3D.map_get_closest_point(NPC.map, move1_target)
	NPC.navigation_agent.target_position = move1_target_adjusted	

func _on_test_main_move_1_state_physics_processing(delta: float) -> void:
	var state = "ATTACK_STAND"
	if NPC.position_direction == -1:
		var anim = "hmn_walk_ls"
		NPC.move_to_target_attack_anim(state, anim)
		
	elif NPC.position_direction == 1:
		var anim = "hmn_walk_rs"
		NPC.move_to_target_attack_anim(state, anim)
		
	var look_at = NPC.enemy.position
	NPC.move_to_target_attack(NPC.circle_target_dist, NPC.move_circle_speed_close, NPC.accel*delta, look_at)	
	if NPC.navigation_agent.is_navigation_finished() : 
		set_test_main_move_target()
		
func _on_test_main_move_1_state_exited() -> void:
	pass # Replace with function body.

#---- ATTACK TEST MOVE 2 ----------------------

func _on_test_main_move_2_state_entered() -> void:
	pass # Replace with function body.

func _on_test_main_move_2_state_physics_processing(_delta: float) -> void:
	pass # Replace with function body.

func _on_test_main_move_2_state_exited() -> void:
	pass # Replace with function body.
#/////////////////////////////// TEST END //////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////

#============================== ATTACK FORWARD ATTACK MAIN

func _on_forward_attack_state_entered() -> void:
	NPC.attack_forward = true
	NPC.cond_attack_fwd_main_tmr.start()
	
func _on_forward_attack_state_physics_processing(_delta: float) -> void:
	pass

func _on_cond_attack_fwd_main_tmr_timeout() -> void:
	if NPC.shoot_done:
		if NPC.move_closer_range:
			$StateChart.send_event("fwd_to_move_closer")
		if NPC.too_close_dist:
			$StateChart.send_event("fwd_to_backdown")
		if NPC.min_circle_dist:
			$StateChart.send_event("fwd_to_move_circle")
		if NPC.min_shoot_dist:								#TEST 
			$StateChart.send_event("fwd_to_shoot")			#TEST
	
func _on_forward_attack_state_exited() -> void:
	NPC.attack_forward = false

#---------------------- FWD MOVE CLOSER ---------------------------------

func _on_move_closer_state_entered() -> void:
	NPC.move_closer_tmr.start_random()
	move_closer_set_target()

func move_closer_set_target():
	var closer_target = Vector3((NPC.global_position.x + NPC.player.global_position.x)/2, (NPC.global_position.y + NPC.player.global_position.y)/2, (NPC.global_position.z + NPC.player.global_position.z)/2)
	var closer_target_adjusted := NavigationServer3D.map_get_closest_point(NPC.map, closer_target)
	NPC.navigation_agent.target_position = closer_target_adjusted
	
func _on_move_closer_state_physics_processing(delta: float) -> void:
	var state = "ATTACK_STAND"
	var anim = "hmn_run_fwd_aim"
	NPC.move_to_target_attack_anim(state, anim)
	
	var look_at = NPC.player.position
	NPC.move_to_target_attack(NPC.travel_target_dist, NPC.move_closer_speed, NPC.accel*delta, look_at)	
	if NPC.navigation_agent.is_navigation_finished() and !NPC.min_circle_dist:
		move_closer_set_target()
		
	if NPC.navigation_agent.is_navigation_finished() and NPC.min_circle_dist:
		$StateChart.send_event("fwd_to_move_circle")
	
	if NPC.min_circle_dist:
		$StateChart.send_event("fwd_to_move_circle")
		
func _on_move_closer_tmr_timeout() -> void:
	if NPC.enemy_spotted:
		$StateChart.send_event("fwd_to_shoot")
	
#---------------------- FWD MOVE CIRCLE ---------------------------------

func _on_move_circle_state_entered() -> void:
	print("circle state")
	set_target_around_circle()
	
func set_target_around_circle():
	var x_offset = randf_range(2.0, 4.0)
	NPC.position_direction = [-1.0, 1.0].pick_random()
	var position_offset = (NPC.transform.basis.x*x_offset)*NPC.position_direction
	var move1_target = NPC.position + position_offset
	var move1_target_adjusted := NavigationServer3D.map_get_closest_point(NPC.map, move1_target)
	NPC.navigation_agent.target_position = move1_target_adjusted
	
func _on_move_circle_state_physics_processing(delta: float) -> void:
	var state = "ATTACK_STAND"
	if NPC.position_direction == -1:
		var anim = "hmn_walk_ls"
		NPC.move_to_target_attack_anim(state, anim)
		
	elif NPC.position_direction == 1:
		var anim = "hmn_walk_rs"
		NPC.move_to_target_attack_anim(state, anim)
	
	var look_at = NPC.enemy.position
	NPC.move_to_target_attack(NPC.circle_target_dist, NPC.move_circle_speed_close, NPC.accel*delta, look_at)
	if NPC.navigation_agent.is_navigation_finished() : 
		$StateChart.send_event("fwd_to_shoot")
	
#---------------------- FWD SHOOT ---------------------------------

func _on_shoot_state_entered() -> void:
	NPC.shoot_done = false

	NPC.look_at(NPC.enemy.position)
	shoot_player.shoot_sequence_standing()

func _on_shoot_state_physics_processing(_delta: float) -> void:
	NPC.look_at(NPC.enemy.position)
	NPC.rotation_degrees.x=0
	NPC.rotation_degrees.z=0

func _on_shoot_state_exited() -> void:
	NPC.count = 0

#---------------------- FWD BACKDOWN ---------------------------------

func _on_backdown_state_entered() -> void:
	var backdown_target = Vector3((NPC.enemy.position) + NPC.global_position)
	var backdown_target_adjusted := NavigationServer3D.map_get_closest_point(NPC.map, backdown_target)
	NPC.navigation_agent.target_position = backdown_target_adjusted	
		
func _on_backdown_state_physics_processing(delta: float) -> void:
	var state = "ATTACK_STAND"
	var anim = "hmn_walk_bwd_aim"
	NPC.move_to_target_attack_anim(state, anim)
	
	var look_at = NPC.enemy.position
	NPC.move_to_target_attack(NPC.stand_target_dist, NPC.move_circle_speed, NPC.accel*delta, look_at)	

	if NPC.min_shoot_dist:
		$StateChart.send_event("fwd_to_shoot")
		
#============================== ATTACK FORWARD ATTACK ALT MAIN

func _on_forward_alt_attack_state_entered() -> void:
	NPC.attack_forward_alt = true
	NPC.cond_attack_fwd_main_alt_tmr.start()

func _on_forward_alt_attack_state_physics_processing(_delta: float) -> void:
	pass # Replace with function body.

func _on_forward_alt_attack_state_exited() -> void:
	NPC.attack_forward_alt = false
	
func _on_cond_attack_fwd_main_alt_tmr_timeout() -> void:
	if NPC.shoot_done:
		if NPC.move_closer_range and !NPC.too_close_dist_alt:
			$StateChart.send_event("fwd_to_move_closer_alt")
			
		if NPC.dist_to_target < 25.0 and NPC.enemy.velocity.length() < 3.0:
			$StateChart.send_event("fwd_to_backdown_alt")
		
		if NPC.dist_to_target < 25.0 and NPC.enemy.velocity.length() > 3.0:
			$StateChart.send_event("fwd_to_retreat_alt")
#	print("player velocity: ", NPC.player.velocity.length())
	
#---------------------- FWD MOVE CLOSER ALT ---------------------------------

func _on_move_closer_alt_state_entered() -> void:
	NPC.move_closer_alt_tmr.start_random()
	move_closer_alt_set_target()

func move_closer_alt_set_target():
	var closer_target = Vector3(NPC.enemy.global_position.x/2, NPC.enemy.global_position.y/2, NPC.enemy.global_position.z/2)	
	var closer_target_adjusted := NavigationServer3D.map_get_closest_point(NPC.map, closer_target)
	NPC.navigation_agent.target_position = closer_target_adjusted

func _on_move_closer_alt_state_physics_processing(delta: float) -> void:
	var state = "ATTACK_STAND"
	var anim = "hmn_walk_fwd_aim"
	NPC.move_to_target_attack_anim(state, anim)
	
	var look_at = NPC.enemy.position
	NPC.move_to_target_attack(NPC.travel_target_dist, NPC.walk_speed, NPC.accel*delta, look_at)	
	if NPC.navigation_agent.is_navigation_finished() and !NPC.min_circle_dist:
		move_closer_alt_set_target()

func _on_move_closer_alt_state_exited() -> void:
	pass # Replace with function body.

func _on_move_closer_alt_tmr_timeout() -> void:
	$StateChart.send_event("fwd_to_shoot_alt")
	
#---------------------- FWD SHOOT ALT ---------------------------------

func _on_shoot_alt_state_entered() -> void:
	NPC.shoot_done = false

	NPC.look_at(NPC.player.position)
	shoot_player.shoot_sequence_standing()

func _on_shoot_alt_state_physics_processing(_delta: float) -> void:
	NPC.look_at(NPC.player.position)
	NPC.rotation_degrees.x=0
	NPC.rotation_degrees.z=0

func _on_shoot_alt_state_exited() -> void:
	NPC.count = 0

#---------------------- FWD BACKDOWN ALT ---------------------------------

func _on_backdown_alt_state_entered() -> void:
	var bkdwn_target = Vector3((NPC.player.position) + NPC.global_position)
	var bkdwn_target_adjusted := NavigationServer3D.map_get_closest_point(NPC.map, bkdwn_target)
	NPC.navigation_agent.target_position = bkdwn_target_adjusted

func _on_backdown_alt_state_physics_processing(delta: float) -> void:
	var state = "ATTACK_STAND"
	var anim = "hmn_walk_bwd_aim"
	NPC.move_to_target_attack_anim(state, anim)
	
	var look_at = NPC.player.position
	NPC.move_to_target_attack(NPC.stand_target_dist, NPC.move_circle_speed, NPC.accel*delta, look_at)	

	if NPC.min_shoot_dist:
		$StateChart.send_event("fwd_to_shoot_alt")

func _on_backdown_alt_state_exited() -> void:
	pass # Replace with function body.		

#---------------------- FWD RETREAT ALT ---------------------------------
	
func _on_retreat_alt_state_entered() -> void:
	print("RETREAT ALT STARTED")
	NPC.retreat_alt_tmr.start_random()
	retreat_alt_set_target()

func retreat_alt_set_target():
	var further_target = Vector3((NPC.player.position) + NPC.global_position)
	var further_target_adjusted := NavigationServer3D.map_get_closest_point(NPC.map, further_target)
	NPC.navigation_agent.target_position = further_target_adjusted

func _on_retreat_alt_state_physics_processing(delta: float) -> void:
	var state = "ATTACK_STAND"
	var anim = "hmn_run_fwd"
	NPC.move_to_target_attack_anim(state, anim)
	
	var look_at = Vector3(NPC.global_position.x + NPC.velocity.x, NPC.global_position.y, NPC.global_position.z + NPC.velocity.z)
	NPC.move_to_target_attack(NPC.cover_target_dist, NPC.run_speed, NPC.accel*delta, look_at)	
	if NPC.navigation_agent.is_navigation_finished():
		retreat_alt_set_target()
		
func _on_retreat_alt_tmr_timeout() -> void:
	$StateChart.send_event("fwd_to_rotate_retreat_alt")
	
#---------------------- FWD ROTATE RETREAT ALT ---------------------------------

func _on_rotate_retreat_alt_state_entered() -> void:
	NPC.retreat_alt_rotate_tmr.start(0.5)

func _on_rotate_retreat_alt_state_physics_processing(delta: float) -> void:
	NPC.animTreePlayBack.travel("ATTACK_STAND")
	NPC.animTreePlayBackAttackStand.travel("hmn_walk_fwd_aim")
	var speed = 2.0
	var target_position = NPC.enemy.transform.origin
	var new_transform = NPC.transform.looking_at(target_position, Vector3.UP)
	NPC.transform  = NPC.transform.interpolate_with(new_transform, speed * delta)
	NPC.rotate_standing_aim(delta)

func _on_retreat_alt_rotate_tmr_timeout() -> void:
	$StateChart.send_event("fwd_to_shoot_alt")
	
#============================== ATTACK COVER ATTACK MAIN

func _on_cover_attack_state_entered() -> void:
	NPC.attack_cover = true
	NPC.cover_scheme = true
	NPC.cover_scheme_tmr.start(10.0)

func _on_cover_attack_state_physics_processing(_delta: float) -> void:

	if NPC.take_cover:
		$StateChart.send_event("to_move_to_cover1")
		
	if NPC.shoot_done and !NPC.reached_cover:
		$StateChart.send_event("to_move_to_cover1")
		
	if NPC.reached_cover:
		$StateChart.send_event("to_move_to_next_cover")
		NPC.circle_around_cover = true
		
	if NPC.shoot_done and NPC.circle_around_cover:
		$StateChart.send_event("to_move_to_next_cover")

func _on_cover_attack_state_exited() -> void:
	NPC.circle_around_cover = false
	NPC.cover_defense_on = false
	NPC.shoot_done = false
	NPC.attack_cover = false
	
func _on_cover_scheme_tmr_timeout() -> void:
	$StateChart.send_event("attack_to_hostile")
	
#---------------------- COVER CHECK ---------------------------------

func _on_cover_check_state_entered() -> void:
	Cover.get_nearest_cover()

#---------------------- MOVE TO COVER 1 ---------------------------------
	
func _on_move_to_cover_1_state_entered() -> void:
	NPC.shoot_done = false
	
	NPC.retreat_tmr.start_random()
	var target_cover_1 = NPC.cover_zone_target.front() # CALLS 1st ITEM IN COVER TARGET LIST
#	print("cover target :", cover_zone_target)
	NPC.navigation_agent.target_position = Vector3(target_cover_1.global_position)
	
func _on_move_to_cover_1_state_physics_processing(delta: float) -> void:
	var state = "ATTACK_STAND"
	var anim = "hmn_run_fwd"
	NPC.move_to_target_attack_anim(state, anim)
	
	var look_at = Vector3(NPC.global_position.x + NPC.velocity.x, NPC.global_position.y, NPC.global_position.z + NPC.velocity.z)
	NPC.move_to_target_attack(NPC.cover_target_dist, NPC.run_speed, NPC.accel*delta, look_at)	
	
	if NPC.navigation_agent.is_navigation_finished():
		NPC.reached_cover = true
		
func _on_retreat_tmr_timeout() -> void:
#	if NPC.enemy_spotted:
		$StateChart.send_event("to_rotate_before_shoot_cover")
	
#---------------------- ROTATE BEFORE SHOOT ---------------------------

func _on_rotate_before_shoot_state_entered() -> void:
	NPC.cover_rotate_tmr.start(0.5)

func _on_rotate_before_shoot_state_physics_processing(delta: float) -> void:
	NPC.animTreePlayBack.travel("ATTACK_STAND")
	NPC.animTreePlayBackAttackStand.travel("hmn_walk_fwd_aim")
	var speed = 2.0
	var target_position = NPC.enemy.transform.origin
	var new_transform = NPC.transform.looking_at(target_position, Vector3.UP)
	NPC.transform  = NPC.transform.interpolate_with(new_transform, speed * delta)
	NPC.rotate_standing_aim(delta)
	
func _on_cover_rotate_tmr_timeout() -> void:
	$StateChart.send_event("to_shoot_retreat")
	
#---------------------- SHOOT RETREAT ---------------------------------

func _on_shoot_retreat_state_entered() -> void:
	NPC.take_cover = false
	NPC.shoot_done = false

	NPC.look_at(NPC.enemy.position)
	shoot_player.shoot_sequence_standing()

func _on_shoot_retreat_state_physics_processing(_delta: float) -> void:
	NPC.look_at(NPC.enemy.position)
	NPC.rotation_degrees.x=0
	NPC.rotation_degrees.z=0

func _on_shoot_retreat_state_exited() -> void:
	NPC.count = 0
	NPC.take_cover = true
#---------------------- SHOOT COVER ---------------------------------

func _on_shoot_cover_state_entered() -> void:
	NPC.shoot_done = false
	NPC.reached_cover = false

	NPC.look_at(NPC.enemy.position)
	shoot_player.shoot_sequence_standing()

func _on_shoot_cover_state_physics_processing(_delta: float) -> void:
	NPC.look_at(NPC.enemy.position)
	NPC.rotation_degrees.x=0
	NPC.rotation_degrees.z=0

func _on_shoot_cover_state_exited() -> void:
	NPC.count = 0

#---------------------- MOVE TO NEXT COVER ---------------------------------

func _on_move_to_next_cover_state_entered() -> void:
	NPC.take_cover = false
	NPC.cover_player_lost = false
	NPC.cover_path_nodes_list = get_tree().get_nodes_in_group("cover_target")
	Cover.get_nearest_cover_zone()
	NPC.cover_stay_tmr.start_random()
	NPC.shoot_done = false
	set_target_next_cover()
		
func set_target_next_cover():
	var rdmx = randf_range(-0.4, 0.4)
	var rdmz = randf_range(-0.4, 0.4)
	var offset = Vector3(rdmx, 0, rdmz)
	var target_path_node = NPC.cover_path_node_target.front()

	NPC.navigation_agent.target_position = Vector3(target_path_node.global_position)+offset

func _on_move_to_next_cover_state_physics_processing(delta: float) -> void:
	NPC.move_around_cover(NPC.accel*delta)
	if NPC.navigation_agent.is_navigation_finished():
		set_target_next_cover()
	
func _on_cover_stay_tmr_timeout() -> void:
#	print("timercheck")
	if NPC.enemy_spotted:
#		print("shoot cover")
		$StateChart.send_event("to_shoot_cover")
	elif !NPC.enemy_spotted:
		print("player lost")
		NPC.cover_player_lost_tmr.start(5.0)
		set_target_next_cover()
		
func _on_cover_player_lost_tmr_timeout() -> void:
	print("enemy lost cover")
	
#	$StateChart.send_event("to_move_to_cover1")

func _on_move_to_next_cover_state_exited() -> void:
	pass
		
#------------------------------------------------
func _on_move_to_next_cover_far_state_entered() -> void:
	pass # Replace with function body.

func _on_move_to_next_cover_far_state_physics_processing(_delta: float) -> void:
	pass # Replace with function body.

#============================== FLANK ATTACK MAIN

func _on_flank_attack_state_entered() -> void:
	NPC.flank_direction = [-1, 1].pick_random()
	NPC.attack_flank = true

func _on_flank_attack_state_physics_processing(_delta: float) -> void:
#	if NPC.move_closer_flank:
#		$StateChart.send_event("to_move_closer_flank")

	if NPC.shoot_done:
		$StateChart.send_event("to_flank_change_position")

func _on_flank_attack_state_exited() -> void:
	NPC.attack_flank = false

#---------------------- FLANK MOVE CLOSER ---------------------------------

func _on_flank_move_closer_state_entered() -> void:
	if NPC.position.distance_to(NPC.enemy.position) > NPC.flank_distance:
		set_target_closer_flank()
	elif NPC.position.distance_to(NPC.enemy.position) <= NPC.flank_distance:
		$StateChart.send_event("to_flank_move_behind")
		
func set_target_closer_flank():
	var position_offset = (NPC.enemy.transform.basis.x*15.0)*NPC.flank_direction
	var target_closer_flank = NPC.enemy.position + position_offset
	var target_closer_flank_adjusted := NavigationServer3D.map_get_closest_point(NPC.map, target_closer_flank)
	NPC.navigation_agent.target_position = target_closer_flank_adjusted
	
func _on_flank_move_closer_state_physics_processing(delta: float) -> void:
	var state = "ATTACK_STAND"
	var anim = "hmn_run_fwd_aim"
	NPC.move_to_target_attack_anim(state, anim)
	
	var look_at = Vector3(NPC.global_position.x + NPC.velocity.x, NPC.global_position.y, NPC.global_position.z + NPC.velocity.z)
	NPC.move_to_target_attack(NPC.stand_target_dist, NPC.move_closer_speed, NPC.accel*delta, look_at)	

	if NPC.navigation_agent.is_navigation_finished():
		$StateChart.send_event("to_flank_move_behind")

func _on_flank_move_closer_state_exited() -> void:
	pass # Replace with function body.

#---------------------- FLANK MOVE BEHIND ---------------------------------

func _on_flank_move_behind_state_entered() -> void:
	pass # Replace with function body.

func _on_flank_move_behind_state_physics_processing(delta: float) -> void:

	NPC.move_behind_setup_target(delta)
	
	if NPC.npc_facing_check < 1.5:
		$StateChart.send_event("to_flank_shoot_behind")

func _on_flank_move_behind_state_exited() -> void:
	pass # Replace with function body.

#---------------------- FLANK SHOOT BEHIND ---------------------------------

func _on_flank_shoot_behind_state_entered() -> void:

	NPC.look_at(NPC.enemy.position)
	shoot_player.shoot_sequence_standing()

func _on_flank_shoot_behind_state_physics_processing(_delta: float) -> void:
	NPC.look_at(NPC.enemy.position)
	NPC.rotation_degrees.x=0
	NPC.rotation_degrees.z=0

func _on_flank_shoot_behind_state_exited() -> void:
	$StateChart.send_event("to_crouch_attack")

#---------------------- FLANK CHANGE POSITION ---------------------------------

func _on_flank_change_position_state_entered() -> void:
	NPC.change_position_tmr.start_random()
	NPC.change_position = false

func _on_flank_change_position_state_physics_processing(delta: float) -> void:
	NPC.move_behind_setup_target(delta)
		
func _on_change_position_tmr_timeout() -> void:
	$StateChart.send_event("to_flank_shoot_behind")
	
func _on_flank_change_position_state_exited() -> void:
	pass # Replace with function body.

#================================= FAR ATTACK MAIN

func _on_far_attack_state_entered() -> void:
	NPC.attack_far = true

func _on_far_attack_state_physics_processing(_delta: float) -> void:
	if NPC.shoot_done:
		if NPC.dist_to_target > NPC.far_attack_limit:
			$StateChart.send_event("to_far_move_close")
		
		if (NPC.dist_to_target < NPC.far_attack_limit and NPC.dist_to_target > NPC.far_attack_limit_retreat):
			var rdm_move = ["to_far_retreat", "to_far_move_side"].pick_random()
			$StateChart.send_event(rdm_move)
		
		if NPC.dist_to_target < NPC.far_attack_limit_retreat:
			NPC.retreat_fast_scheme = true
			$StateChart.send_event("to_far_retreat_fast")
			
	if NPC.dist_to_target > NPC.far_attack_limit_retreat:
		NPC.retreat_fast_scheme = false
		
func _on_far_attack_state_exited() -> void:
	NPC.attack_far = false
	
#---------------------- FAR MOVE CLOSER ---------------------------------

func _on_far_move_close_state_entered() -> void:
	NPC.far_move_closer_tmr.start_random()
	var rdmx = randf_range(-2.0, 2.0)
	var far_move_target = Vector3(NPC.player.global_position.x+rdmx, NPC.player.global_position.y, NPC.player.global_position.z)
	var far_move_target_adjusted := NavigationServer3D.map_get_closest_point(NPC.map, far_move_target)
	NPC.navigation_agent.target_position = far_move_target_adjusted
	
func _on_far_move_close_state_physics_processing(delta: float) -> void:
	var state = "ATTACK_STAND"
	var anim = "hmn_walk_fwd_aim"
	NPC.move_to_target_attack_anim(state, anim)
	
	var look_at = NPC.player.position
	NPC.move_to_target_attack(NPC.stand_target_dist, NPC.walk_speed, NPC.accel*delta, look_at)	

func _on_far_move_closer_tmr_timeout() -> void:
	$StateChart.send_event("to_far_shoot")
	
func _on_far_move_close_state_exited() -> void:
	pass # Replace with function body.
	
#---------------------- FAR SHOOT ---------------------------------

func _on_far_shoot_state_entered() -> void:
	NPC.shoot_done = false

	NPC.look_at(NPC.enemy.position)
	shoot_player.shoot_sequence_standing()

func _on_far_shoot_state_physics_processing(_delta: float) -> void:
	NPC.look_at(NPC.enemy.position)
	NPC.rotation_degrees.x=0
	NPC.rotation_degrees.z=0

func _on_far_shoot_state_exited() -> void:
	NPC.count = 0

#---------------------- FAR RETREAT ---------------------------------

func _on_far_retreat_state_entered() -> void:
	var far_retreat_target = Vector3((NPC.enemy.position) + NPC.global_position)
	var far_retreat_target_adjusted := NavigationServer3D.map_get_closest_point(NPC.map, far_retreat_target)
	NPC.navigation_agent.target_position = far_retreat_target_adjusted
	NPC.far_retreat_tmr.start_random()
			
func _on_far_retreat_state_physics_processing(delta: float) -> void:
	var state = "ATTACK_STAND"
	var anim = "hmn_walk_bwd_aim"
	NPC.move_to_target_attack_anim(state, anim)
	
	var look_at = NPC.enemy.position
	NPC.move_to_target_attack(NPC.stand_target_dist, NPC.walk_speed*1.2, NPC.accel*delta, look_at)	
		
func _on_far_retreat_tmr_timeout() -> void: #THIS TIMER MUST BE CUT FOR FAST SCHEME
	$StateChart.send_event("to_far_shoot")
	
func _on_far_retreat_state_exited() -> void:
	pass # Replace with function body.

#---------------------- FAR MOVE SIDE ---------------------------------

func _on_far_move_side_state_entered() -> void:
	NPC.side_move = [-4.0, -3.0, -2.5,4.0, 3.0, 2.5].pick_random()
	var far_side_target = Vector3(NPC.position.x + NPC.side_move, NPC.position.y, NPC.position.z)
	var far_side_target_adjusted := NavigationServer3D.map_get_closest_point(NPC.map, far_side_target)
	NPC.navigation_agent.target_position = far_side_target_adjusted
	
func _on_far_move_side_state_physics_processing(delta: float) -> void:
	var state
	var anim
	if NPC.side_move < 0:
		state = "ATTACK_STAND"
		anim = "hmn_walk_ls"
	elif NPC.side_move > 0:
		state = "ATTACK_STAND"
		anim = "hmn_walk_rs"
	NPC.move_to_target_attack_anim(state, anim)
	
	var look_at = NPC.enemy.position
	NPC.move_to_target_attack(NPC.stand_target_dist, NPC.walk_speed, NPC.accel*delta, look_at)	
	if NPC.navigation_agent.is_navigation_finished():
		$StateChart.send_event("to_far_shoot")

func _on_far_move_side_state_exited() -> void:
	pass # Replace with function body.

#---------------------- FAR RETREAT FAST ---------------------------------

func _on_far_retreat_fast_state_entered() -> void:
	var rdm_target = Vector3(randf_range(-11.0, 11.0), 0, randf_range(-11.0, 11.0))
	var far_retreat_target = Vector3((NPC.enemy.position) + NPC.global_position / 2) + rdm_target
	var far_retreat_target_adjusted := NavigationServer3D.map_get_closest_point(NPC.map, far_retreat_target)
	NPC.navigation_agent.target_position = far_retreat_target_adjusted
	NPC.far_retreat_fast_tmr.start_random()
	
func _on_far_retreat_fast_state_physics_processing(delta: float) -> void:
	var state = "ATTACK_STAND"
	var anim = "hmn_run_fwd"
	NPC.move_to_target_attack_anim(state, anim)
	
	var look_at = Vector3(NPC.global_position.x + NPC.velocity.x, NPC.global_position.y, NPC.global_position.z + NPC.velocity.z)
	NPC.move_to_target_attack(NPC.cover_target_dist, NPC.run_speed, NPC.accel*delta, look_at)	

func _on_far_retreat_fast_tmr_timeout() -> void:
	$StateChart.send_event("to_far_rotate_to_shoot")
	
func _on_far_retreat_fast_state_exited() -> void:
	pass
	
#---------------------- FAR ROTATE BEFORE SHOOT ------------------------
func _on_far_rotate_to_shoot_state_entered() -> void:
	NPC.far_rotate_tmr.start(0.5)
		
func _on_far_rotate_to_shoot_state_physics_processing(delta: float) -> void:
	NPC.animTreePlayBack.travel("ATTACK_STAND")
	NPC.animTreePlayBackAttackStand.travel("hmn_walk_fwd_aim")
	var speed = 2.0
	var target_position = NPC.enemy.transform.origin
	var new_transform = NPC.transform.looking_at(target_position, Vector3.UP)
	NPC.transform  = NPC.transform.interpolate_with(new_transform, speed * delta)
	NPC.rotate_standing_aim(delta)
	
func _on_far_rotate_tmr_timeout() -> void:
	$StateChart.send_event("to_far_shoot_fast")
	
#---------------------- FAR SHOOT FAST ---------------------------------

func _on_far_shoot_fast_state_entered() -> void:
	NPC.shoot_done = false

	NPC.look_at(NPC.enemy.position)
	shoot_player.shoot_sequence_standing()
	
func _on_far_shoot_fast_state_physics_processing(_delta: float) -> void:
	NPC.look_at(NPC.enemy.position)
	NPC.rotation_degrees.x=0
	NPC.rotation_degrees.z=0

func _on_far_shoot_fast_state_exited() -> void:
	NPC.count = 0

#/////////////////////////////// CROUCH ATTACK ////////////////////////////////

#================================= CROUCH ATTACK MAIN
func _on_crouch_attack_state_entered() -> void:
	NPC.attack_crouch = true

func _on_crouch_attack_state_physics_processing(_delta: float) -> void:
	
	if NPC.shoot_done:
			
		if NPC.dist_to_target < NPC.crouch_fwd_dist:
			var state_target
			var state_list = [1, 2]
			var state_pick = state_list.pick_random()
			if state_pick == 1:
				state_target = "crouch_to_move_circle"
			if state_pick == 2:
				state_target = "crouch_to_move_backwards"
			$StateChart.send_event(state_target)
		
		if NPC.dist_to_target > NPC.crouch_fwd_dist:
			$StateChart.send_event("crouch_to_move_circle")
	
func _on_crouch_attack_state_exited() -> void:
	NPC.attack_crouch = false

#------------------------------- CROUCH MOVE CLOSE ----------------------------

func _on_crouch_move_close_state_entered() -> void:
	NPC.shoot_done = false
	NPC.crouch_move_close_tmr.start_random()
	NPC.navigation_agent.target_position = NPC.enemy.global_position

func _on_crouch_move_close_state_physics_processing(delta: float) -> void:
	var state = "ATTACK_CROUCH"
	var anim = "hmn_walk_fwd_crouch_aim"
	var look_at = NPC.enemy.position
	NPC.move_to_target_crouch_attack(state, anim, NPC.stand_target_dist, NPC.crouch_speed, NPC.accel*delta, look_at)	

func _on_crouch_move_close_state_exited() -> void:
	pass # Replace with function body.
	
func _on_crouch_move_close_tmr_timeout() -> void:
	$StateChart.send_event("crouch_to_shoot")	

#------------------------------- CROUCH MOVE CIRCLE ----------------------------
	
func _on_crouch_move_circle_state_entered() -> void:
	NPC.shoot_done = false
	NPC.circle_direction = [-1, 1].pick_random()
	NPC.crouch_move_circle_tmr.start_random()
	set_crouch_move_circle_target()
	
func set_crouch_move_circle_target():
	var rdmx = 8.0
	var current_position = NPC.position
	NPC.navigation_agent.target_position = Vector3(current_position.x + (rdmx*NPC.circle_direction), current_position.y, current_position.z)

func _on_crouch_move_circle_state_physics_processing(delta: float) -> void:
	var state
	var anim
	if NPC.circle_direction == -1:
		state = "ATTACK_CROUCH"
		anim = "hmn_walk_ls_crouch_aim"
	elif NPC.circle_direction == 1:
		state = "ATTACK_CROUCH"
		anim = "hmn_walk_rs_crouch_aim"
	var look_at = NPC.enemy.position
	NPC.move_to_target_crouch_attack(state, anim, NPC.stand_target_dist, NPC.crouch_speed, NPC.accel*delta, look_at)	

func _on_crouch_move_circle_state_exited() -> void:
	pass # Replace with function body.
	
func _on_crouch_move_circle_timeout() -> void:
	$StateChart.send_event("crouch_to_shoot")

#---------------------------- CROUCH MOVE BACKWARDS ----------------------------

func _on_crouch_move_backwards_state_entered() -> void:
	NPC.shoot_done = false
	var rdm_target = Vector3(randf_range(-7.0, 7.0), 0, randf_range(-7.0, 7.0))
	NPC.navigation_agent.target_position = Vector3((NPC.enemy.position) + NPC.global_position / 2) + rdm_target
	NPC.crouch_move_backwards_tmr.start_random()

func _on_crouch_move_backwards_state_physics_processing(delta: float) -> void:
	var state = "ATTACK_CROUCH"
	var anim = "hmn_walk_bwd_crouch_aim"
	var look_at = NPC.enemy.position
	NPC.move_to_target_crouch_attack(state, anim, NPC.cover_target_dist, NPC.crouch_speed, NPC.accel*delta, look_at)	

func _on_crouch_move_backwards_state_exited() -> void:
	pass # Replace with function body.

func _on_crouch_move_backwards_tmr_timeout() -> void:
	$StateChart.send_event("crouch_to_shoot")

#---------------------------- CROUCH SHOOT -------------------------------------

func _on_crouch_shoot_state_entered() -> void:
	NPC.shoot_done = false

	NPC.look_at(NPC.enemy.position)
	shoot_player.shoot_sequence_crouch()

func _on_crouch_shoot_state_physics_processing(_delta: float) -> void:
	NPC.look_at(NPC.enemy.position)
	NPC.rotation_degrees.x=0
	NPC.rotation_degrees.z=0


func _on_crouch_shoot_state_exited() -> void:
	NPC.count = 0

#/////////////////////////////// MELEE ATTACK ////////////////////////////////

#================================= MELEE ATTACK MAIN

func _on_melee_attack_state_entered() -> void:
	NPC.attack_melee = true

func _on_melee_attack_state_physics_processing(_delta: float) -> void:
	if !NPC.melee_attack_on:
		$StateChart.send_event("fwd_to_backdown")

func _on_melee_attack_state_exited() -> void:
	NPC.attack_melee = false

#---------------------------- MELEE HIT -------------------------------------
	
func _on_melee_hit_state_entered() -> void:
	NPC.animTreePlayBack.travel("ATTACK_MELEE")
	NPC.animTreePlayBackAttackMelee.travel("hmn_stand_idle_aim")

func _on_melee_hit_state_physics_processing(_delta: float) -> void:
	NPC.look_at(NPC.enemy.position)
	NPC.rotation_degrees.x=0
	NPC.rotation_degrees.z=0
	NPC.melee_hit()

func melee_hit_end():
	await get_tree().create_timer(0.2).timeout
	$StateChart.send_event("fwd_to_backdown")
			
#//////////////////////////////////////////////////////////////////////////////

#////////////////////////////// NPC VS NPC COMBAT /////////////////////////////

#======================= NPC VS NPC COMBAT MAIN 

func _on_vsnpccombat_state_entered() -> void:
	NPC.vsnpc_combat_state = true
	NPC.cond_vsnpc_combat_main_tmr.start()

func _on_vsnpccombat_state_physics_processing(_delta: float) -> void:
	if NPC.shoot_done:
		pass
	if NPC.enemy_npc.npc_enemy_off:
		print("enemy off")
		NPC.enemy_npc_spotted = false
		$StateChart.send_event("vsnpc_to_neutral")
		
	if NPC.npc_dead:
		$StateChart.send_event("vsnpc_to_death")
		
func _on_cond_vsnpc_combat_main_tmr_timeout() -> void:
	if NPC.dist_to_target_npc<8.0:
		$StateChart.send_event("vsnpc_to_retreat")
		
	if NPC.dist_to_target_npc>35.0:
		$StateChart.send_event("vsnpc_move_to_target")

	if (NPC.dist_to_target_npc>8.0 and NPC.dist_to_target_npc<35.0):
		$StateChart.send_event("vsnpc_to_circle")
		
#	if NPC.dist_to_target_npc < 35.0:
#		$StateChart.send_event("vsnpc_to_circle")	
						
func _on_vsnpccombat_state_exited() -> void:
	distances_npc.vsnpc_distances_tmr.stop()
	distances_npc.stop_dist_calc_npc()
	NPC.vsnpc_combat_state = false
	detect_vision_npc.enemy_list.clear()
	
#==============================================================================
#---- NPC VS NPC COMBAT SELECTOR

func _on_combat_selector_state_entered() -> void:
	pass # Replace with function body.

#---- NPC VS NPC SHOOT

func _on_vsnpc_shoot_state_entered() -> void:
	NPC.shoot_done = false

	NPC.look_at(NPC.enemy_npc.position)
	shoot_npc.shoot_npc_sequence_standing()


func _on_vsnpc_shoot_state_physics_processing(_delta: float) -> void:
	NPC.look_at(NPC.enemy_npc.position)
	NPC.rotation_degrees.x=0
	NPC.rotation_degrees.z=0

	if NPC.enemy_npc.npc_enemy_off:
		NPC.enemy_npc_spotted = false
		$StateChart.send_event("vsnpc_to_neutral")
		

func _on_vsnpc_shoot_state_exited() -> void:
	NPC.count = 0

#---- NPC VS NPC MOVE TO TARGET

func _on_vsnpc_move_to_target_state_entered() -> void:
	NPC.vsnpc_move_closer_tmr.start_random()
	vsnpc_move_closer_set_target()

func vsnpc_move_closer_set_target():
	if NPC.enemy_npc:
		var closer_target = Vector3((NPC.global_position.x + NPC.enemy_npc.global_position.x)/2, (NPC.global_position.y + NPC.enemy_npc.global_position.y)/2, (NPC.global_position.z + NPC.enemy_npc.global_position.z)/2)	
		var closer_target_adjusted := NavigationServer3D.map_get_closest_point(NPC.map, closer_target)
		NPC.navigation_agent.target_position = closer_target_adjusted
	else: return
	
func _on_vsnpc_move_to_target_state_physics_processing(delta: float) -> void:
	if NPC.enemy_npc:
		var state = "ATTACK_STAND"
		var anim = "hmn_run_fwd_aim"
		NPC.move_to_target_attack_anim(state, anim)
	
		var look_at = NPC.enemy_npc.position
		NPC.move_to_target_attack(NPC.travel_target_dist, NPC.move_closer_speed, NPC.accel*delta, look_at)	
		if NPC.navigation_agent.is_navigation_finished():
			vsnpc_move_closer_set_target()

	else: return
	
func _on_vsnpc_move_closer_tmr_timeout() -> void:
	if NPC.enemy_spotted:
		$StateChart.send_event("vsnpc_to_shoot")

func _on_vsnpc_move_to_target_state_exited() -> void:
	pass # Replace with function body.
	
#---- NPC VS NPC MOVE CIRCLE

func _on_vsnpc_move_circle_state_entered() -> void:
	vsnpc_set_target_around_circle()
	
func vsnpc_set_target_around_circle():
	var x_offset = randf_range(2.0, 4.0)
	NPC.position_direction = [-1.0, 1.0].pick_random()
	var position_offset = (NPC.transform.basis.x*x_offset)*NPC.position_direction
	var move1_target = NPC.position + position_offset
	var move1_target_adjusted := NavigationServer3D.map_get_closest_point(NPC.map, move1_target)
	NPC.navigation_agent.target_position = move1_target_adjusted	


func _on_vsnpc_move_circle_state_physics_processing(delta: float) -> void:
	if NPC.enemy_npc:
		var state = "ATTACK_STAND"
		if NPC.position_direction == -1:
			var anim = "hmn_walk_ls"
			NPC.move_to_target_attack_anim(state, anim)
		
		elif NPC.position_direction == 1:
			var anim = "hmn_walk_rs"
			NPC.move_to_target_attack_anim(state, anim)
	
		var look_at = NPC.enemy_npc.position
		NPC.move_to_target_attack(NPC.circle_target_dist, NPC.move_circle_speed_close, NPC.accel*delta, look_at)	
		if NPC.navigation_agent.is_navigation_finished() : 
			$StateChart.send_event("vsnpc_to_shoot")
	else: return

func _on_vsnpc_move_circle_state_exited() -> void:
	pass # Replace with function body.

		
			
#---- NPC VS NPC RETREAT
func _on_vsnpc_retreat_state_entered() -> void:
	NPC.vsnpc_retreat_tmr.start_random()
	if NPC.enemy_npc:
		var backdown_target = Vector3((NPC.enemy_npc.position) + NPC.global_position)
		var backdown_target_adjusted := NavigationServer3D.map_get_closest_point(NPC.map, backdown_target)
		NPC.navigation_agent.target_position = backdown_target_adjusted	
	else: return

func _on_vsnpc_retreat_state_physics_processing(delta: float) -> void:
	if NPC.enemy_npc:
		var state = "ATTACK_STAND"
		var anim = "hmn_walk_bwd_aim"
		NPC.move_to_target_attack_anim(state, anim)
	
		var look_at = NPC.enemy_npc.position
		NPC.move_to_target_attack(NPC.stand_target_dist, NPC.move_circle_speed, NPC.accel*delta, look_at)	
		
		if (NPC.dist_to_target_npc>8.0 and NPC.dist_to_target_npc<35.0):
			$StateChart.send_event("vsnpc_to_circle")
		
		if NPC.min_shoot_dist:
			$StateChart.send_event("vsnpc_to_shoot")
			
	else: return

func _on_vsnpc_retreat_tmr_timeout() -> void:
	$StateChart.send_event("vsnpc_to_shoot")
	
func _on_vsnpc_retreat_state_exited() -> void:
	pass # Replace with function body.

#/////////////////////////////// INTERIOR ATTACK ////////////////////////////////

#================================= INTERIOR ATTACK MAIN
func _on_interior_attack_state_entered() -> void:
	navigation_agent_3d.path_max_distance = 0.5
	NPC.int_main_attack_tmr.start()
	NPC.interior_combat_state = true
	
func _on_interior_attack_state_physics_processing(_delta: float) -> void:
	pass # Replace with function body.

func _on_int_main_attack_tmr_timeout() -> void:
	if NPC.dist_to_target < 4.0:
		$StateChart.send_event("to_int_backoff")
	if NPC.dist_to_target > 8.0:
		$StateChart.send_event("to_int_move_closer")
		
func _on_interior_attack_state_exited() -> void:
	NPC.interior_combat_state = false
	navigation_agent_3d.path_max_distance = 5.0
	
#==== INTERIOR SHOOT

func _on_int_attack_shoot_state_entered() -> void:
	NPC.shoot_done = false

	NPC.look_at(NPC.enemy.position)
	shoot_player.shoot_sequence_standing()


func _on_int_attack_shoot_state_physics_processing(_delta: float) -> void:
	NPC.look_at(NPC.enemy.position)
	NPC.rotation_degrees.x=0
	NPC.rotation_degrees.z=0


func _on_int_attack_shoot_state_exited() -> void:
	NPC.count = 0

#==== INTERIOR MOVE CLOSER

func _on_int_attack_move_closer_state_entered() -> void:
	NPC.int_move_closer_tmr.start_random()
	var far_move_target = Vector3(NPC.enemy.global_position.x, NPC.enemy.global_position.y, NPC.enemy.global_position.z)
	var far_move_target_adjusted := NavigationServer3D.map_get_closest_point(NPC.map, far_move_target)
	NPC.navigation_agent.target_position = far_move_target_adjusted
	NPC.walk_speed = randf_range(1.1, 1.8)
	
func _on_int_attack_move_closer_state_physics_processing(delta: float) -> void:

	var state = "ATTACK_STAND"
	var anim = "hmn_walk_fwd_aim"
	NPC.move_to_target_attack_anim(state, anim)
	
	var look_at = Vector3(NPC.global_position.x + NPC.velocity.x, NPC.global_position.y, NPC.global_position.z + NPC.velocity.z)
	NPC.move_to_target_attack(NPC.stand_target_dist, NPC.walk_speed*1.5, NPC.accel*delta, look_at)

func _on_int_move_closer_tmr_timeout() -> void:
	$StateChart.send_event("to_int_shoot")
	
func _on_int_attack_move_closer_state_exited() -> void:
	pass # Replace with function body.

#==== INTERIOR BACKOFF

func _on_int_attack_backoff_state_entered() -> void:
	var backoff_target = Vector3((NPC.enemy.position) + NPC.global_position)
	var backoff_target_adjusted := NavigationServer3D.map_get_closest_point(NPC.map, backoff_target)
	NPC.navigation_agent.target_position = backoff_target_adjusted

func _on_int_attack_backoff_state_physics_processing(delta: float) -> void:
	var state = "ATTACK_STAND"
	var anim = "hmn_walk_bwd_aim"
	NPC.move_to_target_attack_anim(state, anim)
	
	var look_at = NPC.enemy.position
	NPC.move_to_target_attack(NPC.stand_target_dist, NPC.move_circle_speed, NPC.accel*delta, look_at)

func _on_int_backoff_tmr_timeout() -> void:
	$StateChart.send_event("to_int_shoot")
	
func _on_int_attack_backoff_state_exited() -> void:
	pass # Replace with function body.

#//////////////////////////////////////////////////////////////////////////////
#/////////////////////////////// DEATH MAIN ///////////////////////////////////

func _on_death_sequence_state_entered() -> void:
	NPC.npc_dead = true
	if NPC.vsnpc_combat_state:
		NPC.remove_from_group(NPC.enemy_npc.detect_vision_npc.npc_enemies)
	NPC.remove_from_group("NPC_vision_coll")
	NPC.npc_enemy_off = true
	NPC.death_sequence()

#//////////////////////////////////////////////////////////////////////////////


#//////////////////////////////////////////////////////////////////////////////
#/////////////////////////    MEET MAIN STATE      ////////////////////////////

#================================= MEET NEUTRAL MAIN

func _on_meet_neutral_state_entered() -> void:
	NPC.meet_neutral_state = true
	NPC.add_to_group("NPC_warning")
	GlobalsNpc.warning_start.emit()
	
func _on_meet_neutral_state_physics_processing(delta: float) -> void:
	
	if !NPC.meet_neutral_dist_on:
		$StateChart.send_event("meet_neutral_to_neutral_main")

		
func _on_meet_neutral_state_exited() -> void:
	NPC.meet_neutral_state = false
	GlobalsNpc.warning_stop.emit()
	NPC.remove_from_group("NPC_warning")
	NPC.remove_from_group("enemy_to_F1")
	NPC.remove_from_group("enemy_to_F2")
	
#---- MEET NEUTRAL STAND TO PLAYER

func _on_stand_to_player_neutral_state_entered() -> void:
	pass # Replace with function body.


func _on_stand_to_player_neutral_state_physics_processing(delta: float) -> void:
		var anim = "hmn_stand_idle_aim"
		var target_look = NPC.neutral_meet.global_position
		NPC.stand_idle_hostile(anim, target_look)
		
		if NPC.neutral_meet_start_attack:
			NPC.enemy = NPC.player
			$StateChart.send_event("meet_neutral_to_attack")

func _on_stand_to_player_neutral_state_exited() -> void:
	pass # Replace with function body.

#============================= MEET FRIEND MAIN


func _on_meet_friend_state_physics_processing(delta: float) -> void:
	var anim = "hmn_stand_idle_neutral"
	var target_look = NPC.player.position
	NPC.stand_idle(anim, target_look)

func _on_meet_friend_state_entered() -> void:
	GlobalsNpc.dialogue_enabled = true
	NPC.add_to_group("NPC_talking")

func _on_meet_friend_state_exited() -> void:
	GlobalsNpc.dialogue_enabled = false
	NPC.remove_from_group("NPC_talking")
