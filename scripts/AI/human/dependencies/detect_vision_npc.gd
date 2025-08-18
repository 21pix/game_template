extends Node
class_name NPCutilDetectVisionNPC

@onready var NPC: NPChuman = $"../.."
@onready var detection_vision_npc_tmr: Timer = $"../../TIMERS/DetectionVisionNPC_tmr"
@onready var vsnpc_vision_tmr: Timer = $"../../TIMERS/VSNPC_Vision_tmr"
@onready var vision_ray_npc: RayCast3D = $"../../VisionRayNPC"
@onready var distances_npc: NPCutilDistancesNPC = $"../DistancesNPC"
@onready var vision_overlap: Area3D = $"../../VisionOverlap"
@onready var enemy_position: Vector3
@onready var enemy_list = []
@onready var npc_enemies: String = NPC.char_desc.reacts_to
@onready var enemy_seen: CharacterBody3D
@onready var enemy_attacker: CharacterBody3D
@onready var closest_object: ClosestObject = $"../ClosestObject"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_vision_npc_delayed()

func start_vision_npc_delayed():
	await get_tree().create_timer(0.2).timeout
	detection_vision_npc_tmr.start()

func _on_detection_vision_npc_tmr_timeout() -> void:
#	overlap_vision_area()
	get_enemies_nearby()
#-------------- PRIMARY VISION CHECK LOOK FOR ENEMIES GROUP --------------------
func overlap_vision_area():
	var overlaps_npc = vision_overlap.get_overlapping_bodies() 
	if overlaps_npc.size() > 0:
		for overlap_npc in overlaps_npc:
	#		if overlap_npc.is_in_group(npc_enemies) and !enemy_list.has(overlap_npc):
			if overlap_npc.is_in_group(npc_enemies) and !overlap_npc.npc_dead:	
				enemy_seen = overlap_npc
				print("enemy_seen : ",enemy_seen)
				enemy_list.append(enemy_seen)
				distances_npc.start_dist_calc_delayed_npc()
				select_enemy()
	#			select_enemy_from_list()
				
			else: return
	else: return
#--------------- ALT ENEMY DETECT
func get_enemies_nearby():
	enemy_list = get_tree().get_nodes_in_group(npc_enemies)
	if enemy_list.size()>= 1:
		get_random_enemy()
	else: return
	
#--------------- GET ATTACKER REFERENCE -------------------------------
func get_attacker_target(attacker_npc: Node): #Called from attacker shoot node
	enemy_attacker = attacker_npc
	print("self : ", NPC.character_self," /// ",  "enemy_attacker : ",enemy_attacker)

	enemy_list.append(enemy_attacker)
#	select_enemy_from_list()
func get_random_enemy():
	NPC.enemy_npc = enemy_list.pick_random()
	get_enemy_target()
	
func get_closest_enemy():
	var minDistance
	var minDistanceEnemy
	for enemy in enemy_list:
		var distance = NPC.position.distance_to(enemy.position)
#		print(distance)

		# This is for our first iteration
		if not minDistanceEnemy:
			minDistance = distance
			minDistanceEnemy = enemy
			continue
		
		if distance < minDistance:
			minDistance = distance
			minDistanceEnemy = enemy
			NPC.enemy_npc = minDistanceEnemy
			get_enemy_target()
	
func select_enemy():
	if enemy_seen and !enemy_attacker:
		NPC.enemy_npc = enemy_seen
		get_enemy_target()
		
	if !enemy_seen and enemy_attacker:
		NPC.enemy_npc = enemy_attacker	
		get_enemy_target()	
		
	if enemy_seen and enemy_attacker:
		if enemy_list.size()>= 1:
			NPC.enemy_npc = enemy_list.pick_random()
			get_enemy_target()
	print("enemy NPC : ",NPC.enemy_npc)
	
func get_enemy_target():
	vsnpc_vision_tmr.start()

func _on_vsnpc_vision_tmr_timeout() -> void:
	if NPC.enemy_npc and !NPC.enemy_npc.npc_dead:
		enemy_position = NPC.enemy_npc.global_transform.origin+Vector3(0,1,0)
		vision_ray_npc.look_at(enemy_position, Vector3.UP)
		vision_ray_npc.force_raycast_update()			
		if vision_ray_npc.is_colliding():
			var Vcollider = vision_ray_npc.get_collider()
			if Vcollider.is_in_group("NPC_vision_coll"):
				vision_ray_npc.debug_shape_custom_color = Color(255,128,0)
				NPC.enemy_npc_spotted = true
#				print("enemy NPC: ", Vcollider)
			else :
				vision_ray_npc.debug_shape_custom_color = Color(0,255,0)
				NPC.enemy_npc_spotted = false
		else:
			vision_ray_npc.debug_shape_custom_color = Color(83,84,215)
	else: return
