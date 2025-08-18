extends CharacterBody3D
class_name NPChuman

#---- SELF REFERENCE FOR SPAWN
@onready var character_self: NPChuman = $"."
@onready var squad_id: String

#---- DEPENDENCIES
@onready var character_main: NPCcharactermain = $Dependencies/CharacterMain
@onready var character_wpn = $Dependencies/CharacterWeapon
@export var char_desc = Resource
@onready var detect_vision_npc: NPCutilDetectVisionNPC = $Dependencies/DetectVisionNPC

#---- NAVIGATION
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var main_map = get_tree().get_first_node_in_group("Map")
@onready var map := get_world_3d().navigation_map

#---- TARGETS
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var enemy: CharacterBody3D
@onready var neutral_meet: CharacterBody3D
@onready var friend_meet: CharacterBody3D
@onready var enemy_npc: CharacterBody3D

@onready var cover_area = preload("res://assets/scenes/logic/coverzone.tscn")
@onready var cover_cast: ShapeCast3D = $CoverCast

#-----GENERIC VARIABLES ------------------------
@onready var ObjectList = []
@onready var ObjectTarget
@onready var Target
signal NPCshoot

#---- VISION NODES
@onready var vision_ray: RayCast3D = $VisionRay
@onready var vision_cone: Area3D = $Armature/VisionCone

#---- SHOOT RAYCAST
@onready var shoot_ray: RayCast3D = $ShootRay

#---- SOUND
@onready var npc_sound_player: AudioStreamPlayer3D = $NPCSoundPlayer

#---- ANIMATION NODES
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree2
@onready var animTreePlayBack : AnimationNodeStateMachinePlayback = $AnimationTree2.get("parameters/StateMachine/playback")
@onready var animTreePlayBackNeutral : AnimationNodeStateMachinePlayback = $AnimationTree2.get("parameters/StateMachine/NEUTRAL/playback")
@onready var animTreePlayBackHostile : AnimationNodeStateMachinePlayback = $AnimationTree2.get("parameters/StateMachine/HOSTILE/playback")
@onready var animTreePlayBackAttackStand : AnimationNodeStateMachinePlayback = $AnimationTree2.get("parameters/StateMachine/ATTACK_STAND/playback")
@onready var animTreePlayBackAttackMelee : AnimationNodeStateMachinePlayback = $AnimationTree2.get("parameters/StateMachine/ATTACK_MELEE/playback")
@onready var animTreePlayBackAttackCrouch : AnimationNodeStateMachinePlayback = $AnimationTree2.get("parameters/StateMachine/ATTACK_CROUCH/playback")
@onready var animTreePlayBackDeath : AnimationNodeStateMachinePlayback = $AnimationTree2.get("parameters/StateMachine/DEATH/playback")
@onready var animTreeFade : AnimationNodeStateMachineTransition = $AnimationTree2.get("parameters/StateMachine/Transition")

#---- TIMERS

@onready var cond_attack_fwd_main_tmr: Timer = $TIMERS/Cond_attack_fwd_main_tmr
@onready var cond_attack_main_tmr: Timer = $TIMERS/Cond_attack_main_tmr
@onready var cond_attack_fwd_main_alt_tmr: Timer = $TIMERS/Cond_attack_fwd_main_alt_tmr
@onready var cond_vsnpc_combat_main_tmr: Timer = $TIMERS/Cond_vsnpc_combat_main_tmr

@onready var stand_up_tmr: Timer = $TIMERS/StandUp_tmr
@onready var enemy_spotted_tmr: Timer = $TIMERS/EnemySpotted_tmr
@onready var look_for_tmr: Timer = $TIMERS/LookFor_tmr
@onready var shoot_tmr: RandomTimer = $TIMERS/Shoot_tmr

@onready var int_main_attack_tmr: Timer = $TIMERS/IntMainAttack_tmr
@onready var int_move_closer_tmr: RandomTimer = $TIMERS/IntMoveCloser_tmr
@onready var int_backoff_tmr: RandomTimer = $TIMERS/IntBackoff_tmr

@onready var meet_rotate_tmr: Timer = $TIMERS/MeetRotate_tmr

@onready var move_to_enemy_tmr: Timer = $TIMERS/MoveToEnemy_tmr
@onready var move_closer_tmr: RandomTimer = $TIMERS/MoveCloser_tmr
@onready var move_closer_alt_tmr: RandomTimer = $TIMERS/MoveCloserAlt_tmr
@onready var retreat_tmr: RandomTimer = $TIMERS/Retreat_tmr
@onready var retreat_alt_tmr: RandomTimer = $TIMERS/Retreat_alt_tmr
@onready var retreat_alt_rotate_tmr: Timer = $TIMERS/Retreat_alt_rotate_tmr
@onready var vsnpc_move_closer_tmr: RandomTimer = $TIMERS/VSNPC_MoveCloser_tmr
@onready var vsnpc_retreat_tmr: RandomTimer = $TIMERS/VSNPC_retreat_tmr

@onready var cover_scheme_tmr: Timer = $TIMERS/CoverScheme_tmr
@onready var cover_rotate_tmr: Timer = $TIMERS/CoverRotate_tmr
@onready var check_cover_tmr: Timer = $TIMERS/CheckCover_tmr
@onready var cover_stay_tmr: RandomTimer = $TIMERS/CoverStay_tmr
@onready var cover_stay_far_tmr: RandomTimer = $TIMERS/CoverStayFar_tmr
@onready var change_position_tmr: RandomTimer = $TIMERS/ChangePosition_tmr
@onready var cover_player_lost_tmr: Timer = $TIMERS/CoverPlayerLost_tmr

@onready var patrol_observe_tmr: Timer = $TIMERS/PatrolObserve_tmr
@onready var npc_count_tmr: Timer = $TIMERS/NPCCount_tmr
@onready var camp_enter: RandomTimer = $TIMERS/CampEnter

@onready var crouch_move_circle_tmr: RandomTimer = $TIMERS/CrouchMoveCircle_tmr
@onready var crouch_move_close_tmr: RandomTimer = $TIMERS/CrouchMoveClose_tmr
@onready var crouch_atk_tmr: RandomTimer = $TIMERS/CrouchAtk_tmr
@onready var crouch_move_backwards_tmr: RandomTimer = $TIMERS/CrouchMoveBackwards_tmr

@onready var far_move_closer_tmr: Timer = $TIMERS/FarMoveCloser_tmr
@onready var far_retreat_tmr: RandomTimer = $TIMERS/FarRetreat_tmr
@onready var far_retreat_fast_tmr: RandomTimer = $TIMERS/FarRetreatFast_tmr
@onready var far_rotate_tmr: Timer = $TIMERS/FarRotate_tmr

#---- VARIABLES DETECTION
var distance_to_cover: float = 20.0
var direction = Vector3()
var hear_dist: float = 30.0
var cover_crouch_dist: float = 30.0
var hear_dist_shot: float = 90.0

#---- VARIABLES MOVEMENT
var meet_neutral_dist: float = 10.0
var meet_neutral_attack_dist: float = 6.0

var alert_dist: float = 55.0
var circle_range_max: float = 18.0
var circle_range_min: float = 10.0
var min_shoot_range: float = 9.0
var backdown_range_max: float = 10.0
var melee_range: float = 2.0

var far_attack_limit: float = 45.0
var far_attack_limit_retreat: float = 35.0

var npc_facing_check: float

var crouch_fwd_dist: float = 25.0
var crouch_bwd_dist: float = 10.0

var closest_cover: Object
var closest_cover_zone: Node3D
var closest_sit_spot: Area3D
var closest_main_camp: Area3D

var minDistanceObject

#---- VARIABLES MOVEMENT
var position_offset_A: Vector3
var position_offset_B: Vector3
var side_move: float
var dist_to_target: float
var dist_to_target_npc: float
var walk_speed = randf_range(1.3, 1.7)
var crouch_speed = randf_range(2.2, 2.8)
var look_for_speed = randf_range(1.5, 2.0)
var move_closer_speed = randf_range(3.9, 4.5)
var move_circle_speed = randf_range(2.6, 3.2)
var move_circle_speed_close = randf_range(2.0, 2.5)
var run_speed = randf_range(4.0, 5.0)
var accel: float= 4.0
var radius:float = 10
var angle:float = 0.0
var circle_motion_list = [-6,-4,-3,3,4,6]
var flank_distance: float = 15.0
var flank_direction = []  # +1 for right, -1 for left
var circle_direction: int
var orbit_speed = randf_range(1.9, 2.1)  # How fast the AI moves around the player

var travel_target_dist: float = 2.0
var guard_target_dist: float = 1.0
var sit_target_dist: float = 0.3
var stand_target_dist: float = 0.8
var cover_target_dist: float = 3.0
var circle_target_dist: float = 1.0

#---- CONDITIONS BOOLEANS
var neutral_meet_spotted: bool = false
var neutral_meet_start_attack: bool = false
var friend_meet_spotted: bool = false
var enemy_spotted: bool= false
var enemy_npc_spotted: bool= false
var enemy_detected: bool= false
var enemy_lost: bool = false
var enemy_search_fail: bool = false
var player_noisy_close: bool= false
var player_noisy_far: bool= false
var player_hit_success: bool = false
var interior_restrictor_on: bool = false

var enemy_spotter_tmr_on: bool = false

var neutral_state: bool = false
var meet_state: bool = false
var alert_state: bool= false
var hostile_state: bool = false
var attack_state: bool = false
var vsnpc_combat_state: bool = false
var interior_combat_state: bool = false

var attack_forward: bool = false
var attack_forward_alt: bool = false
var attack_cover: bool = false
var attack_flank: bool = false
var attack_crouch: bool = false
var attack_far: bool = false
var attack_melee: bool = false

var meet_neutral_state: bool = false
var meet_friend_state: bool = false

var meet_neutral_dist_on: bool = false
var meet_friend_dist_on: bool = false
var retreat_fast_scheme: bool = false
var attack_dist_on: bool = false
var move_closer_range: bool= false
var min_circle_dist: bool= false
var min_shoot_dist: bool= false
var too_close_dist: bool= false
var too_close_dist_alt: bool = false
var melee_attack_on: bool= false
var attack_seq_on: bool= false
var shoot_done: bool = false

var cover_defense_on: bool = false
var cover_available: bool = false
var cover_player_lost: bool = false
var cover_scheme: bool = false

var npc_dead: bool = false
var npc_enemy_off: bool = false

var take_cover: bool = false
var circle_around_cover: bool = false
var reached_cover: bool = false

var reached_guard_spot: bool = false
var reached_patrol_spot: bool = false
var reached_sit_spot: bool = false
var reached_idle_spot: bool = false
var trans_stand_to_sit: bool = false
var reached_main_camp: bool = false

var rotation_standing_start: bool = false
var rotation_standing_done: bool = false

var shoot_while_retreat_start: bool = false
var shoot_from_cover_start: bool= false
var shoot_from_cover_done: bool= false
var shoot_from_retreat_done: bool= false
var shoot_from_behind_start: bool= false
var shoot_from_behind_done: bool= false
var shoot_move_circle_start: bool = false
var shoot_move_circle_done: bool= false
var shoot_crouch_start: bool = false
var shoot_crouch_done: bool = false

var reached_flank_start: bool= false
var reached_flank_dest: bool= false
var move_closer_flank: bool= false
var change_position: bool= false

var crouch_fwd_on: bool = false
var crouch_bwd_on: bool = false

var camp_scheme: bool = false
var guard_scheme: bool = false
var patrol_scheme: bool = false
var sit_scheme: bool = false
var patrol_observe_done: bool = false
var patrol_index: int = 0
var patrol_list_set: bool = false
var camp_main_target_set: bool = false
var camp_main_list_set: bool = false
var sit_spot_target_acquired: bool = false

#---- ATTACK STATES SELECTOR
var attack_states_list2 = [1, 1, 1, 2, 2, 2, 3, 3]
var attack_states_list3 = [1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4]
var attack_states_list4 = [1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 5]
var attack_state_select1: int
var attack_state_select2: int
var attack_state_select3: int
var attack_state_select4: int

var campMainList = [] # all main camps list
var campList = []
var campSitSpot = []
var campActivityList = []
var patrolPointList = []
var guardPointList = []
var sitPointList = []
var campTarget
var cover_list_detected = []
var cover_list = []
var cover_zones_list = [] #list of available cover zones from area logic
var cover_path_nodes_list = [] #list of available cover path nodes
var cover_zone_target = [] #closest cover zone point
var cover_path_node_target = []
var sit_spot_target
var NPC_List = []

#---- HEALTH
var health: int= 100


#---- RANDOMIZER 
@onready var rdmzr = randf_range(0.7, 1.4)
@onready var safety_factor = randf_range(1.2, 1.4)
@onready var position_direction = []

#---- CONDITIONS BOOLEANS


#---- SHOOT VARIABLES
var count: int= 0
var shot_count: int
var shot_time: int

#---- GET SIGNALS
func _ready() -> void:

	npc_sound_player.stream = character_wpn.wpn_sound
	shot_count = randi_range(1, character_wpn.wpn_max_shots)
	shot_time = character_wpn.wpn_shot_time
	
############################ COVER CHECK
func check_active_cover():
	pass

func get_cover_list_alt():
	self.cover_list_detected.clear()
	cover_cast.force_shapecast_update()
	if cover_cast.is_colliding():
		#
		for i in cover_cast.get_collision_count():
			var body = cover_cast.get_collider(i)
		#

#			print(body)
			if body.is_in_group("Cover") and !self.cover_list.has(body):
				self.cover_available = true
				self.cover_list_detected.append(body)
				self.cover_list = self.cover_list_detected
#				print("cover list", cover_list)

############################ 

#=============================================================================
# NEUTRAL STATE JOBS SETUP
#===============================================
func set_patrol_on(patrol): #THIS FUNC IS CALLED FROM LOGIC NODE - RECIEVES PATROL POINTS THROUGH "patrol" argument
	if self.neutral_state:
		self.patrol_scheme = true
		self.patrolPointList = patrol
	else :
		return

func set_guard_on(guard): #THIS FUNC IS CALLED FROM LOGIC NODE
	if self.neutral_state:
		self.guard_scheme = true
		self.guardPointList = guard
	else :
		return
		
func start_camp_scheme(): #THIS FUNC IS CALLED FROM CAMP MAIN NODE
	if self.neutral_state:
		self.camp_main_target_set = false
		self.camp_scheme = true
	else :
		return
		
func set_sit_on(sit): #THIS FUNC IS CALLED FROM CAMP MAIN NODE
	if self.neutral_state:
		self.sit_scheme = true
		self.sitPointList = sit
	else :
		return
		
#===================== OTHER NPC CHECK ========================================
func get_active_NPC():
	self.NPC_List = get_tree().get_nodes_in_group("NPC_unit")
#==============================================================================

#///////////////////// MOVEMENTS //////////////////////////////////////

#---- SET MOVE TARGET 
func set_target(Target):
	navigation_agent.target_position = Target

#---- MOVE WALKING
func move_to_target_anim(state, anim):
	animation_tree.set("parameters/TimeScale/scale", 1.3)
	animTreePlayBack.travel(state)
	animTreePlayBackNeutral.travel(anim)

func move_to_target(target_dist, speed, accel, look_at):
	navigation_agent.target_desired_distance = target_dist

	self.direction = navigation_agent.get_next_path_position() - global_position # Move 
	self.direction = self.direction.normalized()
	velocity = velocity.lerp(self.direction * speed, accel)
	
	self.rotation_degrees.x=0
	self.rotation_degrees.z=0
	look_at(look_at, Vector3.UP)
	move_and_slide()	
#----------------------------------
func move_to_target_hostile_anim(state, anim):
	animation_tree.set("parameters/TimeScale/scale", 1.3)
	animTreePlayBack.travel(state)
	animTreePlayBackHostile.travel(anim)	
	
func move_to_target_hostile(target_dist, speed, accel, look_at):
	navigation_agent.target_desired_distance = target_dist

	self.direction = navigation_agent.get_next_path_position() - global_position # Move 
	self.direction = self.direction.normalized()
	velocity = velocity.lerp(self.direction * speed, accel)
	
	self.rotation_degrees.x=0
	self.rotation_degrees.z=0
	look_at(look_at, Vector3.UP)
	move_and_slide()	
#----------------------------------
func move_to_target_attack_anim(state, anim):
	animation_tree.set("parameters/TimeScale/scale", 1.2)
	animTreePlayBack.travel(state)
	animTreePlayBackAttackStand.travel(anim)
		
func move_to_target_attack(target_dist, speed, accel, look_at):
	navigation_agent.target_desired_distance = target_dist

	self.direction = navigation_agent.get_next_path_position() - global_position # Move 
	self.direction = self.direction.normalized()
	velocity = velocity.lerp(self.direction * speed, accel)
	
	self.rotation_degrees.x=0
	self.rotation_degrees.z=0
	look_at(look_at, Vector3.UP)
	move_and_slide()	

func move_to_target_crouch_attack(state, anim, target_dist, speed, accel, look_at):
	animation_tree.set("parameters/TimeScale/scale", 1.8)
	animTreePlayBack.travel(state)
	animTreePlayBackAttackCrouch.travel(anim)
	navigation_agent.target_desired_distance = target_dist

	self.direction = navigation_agent.get_next_path_position() - global_position # Move 
	self.direction = self.direction.normalized()
	velocity = velocity.lerp(self.direction * speed, accel)
	
	self.rotation_degrees.x=0
	self.rotation_degrees.z=0
	look_at(look_at, Vector3.UP)
	move_and_slide()	
	
func move_from_target_attack(state, anim, target_dist, speed, accel, look_at):
	animation_tree.set("parameters/TimeScale/scale", 1.2)
	animTreePlayBack.travel(state)
	animTreePlayBackAttackStand.travel(anim)
	navigation_agent.target_desired_distance = target_dist

	self.direction = navigation_agent.get_next_path_position() + global_position # Move 
	self.direction = self.direction.normalized()
	velocity = velocity.lerp(self.direction * speed, accel)
	
	self.rotation_degrees.x=0
	self.rotation_degrees.z=0
	look_at(look_at, Vector3.UP)
	move_and_slide()
		
#---- MOVE AROUND COVER

func move_around_cover(accel):
	var side_dir = self.global_transform.basis.x

	if side_dir.x < -0.1:
		animation_tree.set("parameters/TimeScale/scale", 1.2)
		animTreePlayBack.travel("ATTACK_STAND")
		animTreePlayBackAttackStand.travel("hmn_walk_ls")
	if side_dir.x > 0.1:
		animation_tree.set("parameters/TimeScale/scale", 1.2)
		animTreePlayBack.travel("ATTACK_STAND")
		animTreePlayBackAttackStand.travel("hmn_walk_rs")
	elif side_dir.x > -0.1 and side_dir.x < 0.1:
		animation_tree.set("parameters/TimeScale/scale", 0.2)
		animTreePlayBack.travel("ATTACK_STAND")
		animTreePlayBackAttackStand.travel("hmn_walk_fwd_aim")
#	print("cover point:", cover_point_target.global_position)
	self.direction = navigation_agent.get_next_path_position() - global_position # Move 
	self.direction = self.direction.normalized()
	velocity = velocity.lerp(self.direction * self.run_speed, accel)
	
	look_at(player.position)
	self.rotation_degrees.x=0
	self.rotation_degrees.z=0
	move_and_slide()

#---- MOVE FORWARD CIRCLE
func move_forward_circle(target_dist, accel):
	var side_dir = self.global_transform.basis.x
	var front_dir = self.global_transform.basis.z

	if front_dir.x < -0.1:
		animation_tree.set("parameters/TimeScale/scale", 1.2)
		animTreePlayBack.travel("ATTACK_STAND")
		animTreePlayBackAttackStand.travel("hmn_walk_fwd_aim")
	if front_dir.x > 0.1:
		animation_tree.set("parameters/TimeScale/scale", 1.2)
		animTreePlayBack.travel("ATTACK_STAND")
		animTreePlayBackAttackStand.travel("hmn_walk_bwd_aim")
		
	if side_dir.x < -0.1:
		animation_tree.set("parameters/TimeScale/scale", 1.2)
		animTreePlayBack.travel("ATTACK_STAND")
		animTreePlayBackAttackStand.travel("hmn_walk_ls")
	if side_dir.x > 0.1:
		animation_tree.set("parameters/TimeScale/scale", 1.2)
		animTreePlayBack.travel("ATTACK_STAND")
		animTreePlayBackAttackStand.travel("hmn_walk_rs")
	elif side_dir.x > -0.1 and side_dir.x < 0.1:
		animation_tree.set("parameters/TimeScale/scale", 0.2)
		animTreePlayBack.travel("ATTACK_STAND")
		animTreePlayBackAttackStand.travel("hmn_walk_fwd_aim")
#	print("cover point:", cover_point_target.global_position)
	self.direction = navigation_agent.get_next_path_position() - global_position # Move 
	self.direction = self.direction.normalized()
	velocity = velocity.lerp(self.direction * self.run_speed, accel)
	navigation_agent.target_desired_distance = target_dist
	look_at(player.position)
	self.rotation_degrees.x=0
	self.rotation_degrees.z=0
	move_and_slide()
	
#---- FLANK MOVE BEHIND SETUP TARGET

func move_behind_setup_target(delta: float):
	var target = player
	if self.flank_direction == 1:
		animTreePlayBack.travel("ATTACK_STAND")
		animTreePlayBackAttackStand.travel("hmn_walk_ls")
	elif self.flank_direction == -1:
		animTreePlayBack.travel("ATTACK_STAND")
		animTreePlayBackAttackStand.travel("hmn_walk_rs")
		
	if target:
		# Calculate a position orbiting around the player
		var to_target = global_position - target.global_position
		var right_vector = target.global_transform.basis.x  # Right direction of the player
		var orbit_offset = right_vector * self.flank_direction * self.orbit_speed * delta
		
		# Maintain a circular distance around the player
		var desired_position = target.global_position + to_target.normalized() * self.flank_distance + orbit_offset
		var desired_position_adjusted := NavigationServer3D.map_get_closest_point(map, desired_position)
	
		move_to_target_behind(desired_position_adjusted, delta)
		
	var pl_trb = player.get_global_transform().basis.z
	var npc_trb = self.get_global_transform().basis.z
	var directionFace = npc_trb - pl_trb
	self.npc_facing_check = directionFace.dot(self.transform.basis.z)
	
		
#---- FLANK MOVE BEHIND

func move_to_target_behind(destination: Vector3, _delta: float):
	var direction = (destination - global_position).normalized()
	velocity = direction * self.run_speed
	navigation_agent.target_desired_distance = self.travel_target_dist
	
	if navigation_agent.is_navigation_finished():
		self.reached_flank_dest = true
		
	move_and_slide()

	look_at(player.global_position, Vector3.UP)

#---- ROTATE STANDING
func rotate_standing_aim(delta: float):
	animTreePlayBack.travel("ATTACK_STAND")
	animTreePlayBackAttackStand.travel("hmn_walk_fwd_aim")
	var speed = 12.0
	var target_position = player.transform.origin
	var new_transform = transform.looking_at(target_position, Vector3.UP)
	self.transform  = self.transform.interpolate_with(new_transform, speed * delta)

func rotate_standing_neutral(delta: float):
	animTreePlayBack.travel("NEUTRAL")
	animTreePlayBackNeutral.travel("hmn_walk_fwd")
	var speed = 8.0
	var target_position = player.transform.origin
	var new_transform = transform.looking_at(target_position, Vector3.UP)
	self.transform  = self.transform.interpolate_with(new_transform, speed * delta)
	
#---- STAND IDLE

func stand_idle(anim, target_look):
	animTreePlayBack.travel("NEUTRAL")
	animTreePlayBackNeutral.travel(anim)
	self.rotation_degrees.x=0
	self.rotation_degrees.z=0	
	look_at(target_look, Vector3.UP)

func stand_idle_hostile(anim, target_look):
	animTreePlayBack.travel("HOSTILE")
	animTreePlayBackHostile.travel(anim)
	self.rotation_degrees.x=0
	self.rotation_degrees.z=0	
	look_at(target_look, Vector3.UP)
	
#---- TRANS STAND TO SIT LOW

func stand_to_sit_low():
	var direction_to_target = (self.campTarget.global_transform.origin - global_transform.origin).normalized() #look at opposite direction
	var opposite_direction = -direction_to_target
	var target_position = global_transform.origin + opposite_direction
	look_at(target_position, Vector3.UP)
	animation_tree.set("parameters/TimeScale/scale", 1.0)
	animTreePlayBack.travel("NEUTRAL")
	animTreePlayBackNeutral.travel("hmn_trans_stand_to_sit_low")
	
#---- SET STAND IDLE SPOT TARGET

func set_target_idle_spot():
	var idle_spot_rdmx = randf_range(5.0, -5.0)
	var idle_spot_rdmz = randf_range(5.0, -5.0)
	var camp_target_loc = self.campTarget.position
	var target_idle_spot = Vector3(camp_target_loc.x + idle_spot_rdmx, camp_target_loc.y, camp_target_loc.z + idle_spot_rdmz)
	
	var map := get_world_3d().navigation_map
	var closest_idle_point := NavigationServer3D.map_get_closest_point(map, target_idle_spot)
	var movement_target_position = closest_idle_point
	set_movement_target_idle_spot(movement_target_position)
	
func set_movement_target_idle_spot(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)


		
#---- MELEE HIT

func melee_hit():
	animTreePlayBack.travel("ATTACK_MELEE")
	animTreePlayBackAttackMelee.travel("hmn_stand_melee_1")
	await get_tree().create_timer(0.2).timeout
	animTreePlayBack.travel("ATTACK_MELEE")
	animTreePlayBackAttackMelee.travel("hmn_stand_idle_aim")

func melee_hit_damage():
	player.hit()
	player.damage(20.0)	
#================================================

func death_sequence():
	remove_from_group("NPC_unit")
	remove_from_group("Enemy")
	animTreePlayBack.travel("DEATH")
	animTreePlayBackDeath.travel("hmn_stand_death")
	character_main.drop_items()
	await get_tree().create_timer(10.0).timeout
	queue_free()
