extends Node
class_name NPCutilDistances

@onready var player_target: CharacterBody3D
@onready var NPC: NPChuman = $"../.."
@onready var distances_tmr: Timer = $"../../TIMERS/Distances_tmr"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	start_dist_calc_delayed()
	pass
	
func start_dist_calc_delayed():
	await get_tree().create_timer(0.2).timeout
	player_target = get_tree().get_first_node_in_group("Player")
	distances_tmr.start(0.1)

func stop_dist_calc():
	distances_tmr.stop()
	
func _on_distances_tmr_timeout() -> void:

	var player_pos = player_target.position 
	var npc_pos = NPC.position
	NPC.dist_to_target = player_pos.distance_to(npc_pos)
	
#MEET NEUTRAL DISTANCE
	if NPC.dist_to_target < NPC.meet_neutral_dist:
		NPC.meet_neutral_dist_on = true
	elif NPC.dist_to_target > NPC.meet_neutral_dist:
		NPC.meet_neutral_dist_on = false

#MEET NEUTRAL ATTACK DISTANCE
	if NPC.dist_to_target < NPC.meet_neutral_attack_dist:
		NPC.neutral_meet_start_attack = true
	elif NPC.dist_to_target > NPC.meet_neutral_attack_dist+2.0:
		NPC.neutral_meet_start_attack = false
		
		
#MINIMUM CIRCLE DISTANCE 
	if NPC.dist_to_target < NPC.circle_range_max and NPC.dist_to_target > NPC.circle_range_min:
		NPC.min_circle_dist = true
	elif NPC.dist_to_target > NPC.circle_range_max:
		NPC.min_circle_dist = false 
	elif NPC.dist_to_target < NPC.circle_range_min:
		NPC.min_circle_dist = false
		
#MINIMUM SHOOT DISTANCE 
	if NPC.dist_to_target > NPC.min_shoot_range:
		NPC.min_shoot_dist = true
	elif NPC.dist_to_target < NPC.min_shoot_range:
		NPC.min_shoot_dist = false
		
#MINIMUM BACKDOWN DISTANCE 
	if NPC.dist_to_target < NPC.backdown_range_max and NPC.dist_to_target > NPC.melee_range:
		NPC.too_close_dist = true
	elif NPC.dist_to_target > NPC.backdown_range_max:
		NPC.too_close_dist = false 
	elif NPC.dist_to_target < NPC.melee_range:
		NPC.too_close_dist = false

#MINIMUM BACKDOWN ALT DISTANCE 
	if NPC.dist_to_target < NPC.circle_range_max and NPC.dist_to_target > NPC.melee_range:
		NPC.too_close_dist_alt = true
	elif NPC.dist_to_target > NPC.circle_range_max:
		NPC.too_close_dist_alt = false 
	elif NPC.dist_to_target < NPC.melee_range:
		NPC.too_close_dist_alt = false
		
#MOVE CLOSER RANGE DISTANCE
	if NPC.dist_to_target < NPC.alert_dist and NPC.dist_to_target > NPC.circle_range_max:
		NPC.move_closer_range = true
	else : NPC.move_closer_range = false

		
#MELEE ATTACK DISTANCE
	if NPC.dist_to_target <= NPC.melee_range:
		NPC.melee_attack_on = true
	else: NPC.melee_attack_on = false

#TRIGGER ATTACK DISTANCE
	if NPC.dist_to_target <= NPC.alert_dist:
		NPC.attack_dist_on = true
	elif NPC.dist_to_target >= NPC.alert_dist:
		NPC.attack_dist_on = false


		
	# ALERT ZONE CONDITIONS
	if !NPC.attack_state:
		if NPC.dist_to_target > NPC.alert_dist and NPC.enemy_spotted:
			NPC.alert_state = true
		
		if !NPC.enemy_spotted:
			NPC.alert_state = false
