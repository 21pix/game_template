extends Node
class_name GameSpawnActors

@onready var tasks_logic: GameTasksLogic = $"../task_manager/tasks_logic"
@onready var spwn_node: Array
@onready var spawner: Node
@onready var squads_node: Array
@onready var squads: Node
@onready var items_node: Node
@onready var spawned_squads_list: Array
@onready var squads_alive_list: Array
@onready var spawned_npc_list: Array
@onready var npc_dic: Dictionary
@onready var squad_count: int
@onready var mob: int
@onready var player: CharacterBody3D
@onready var player_pos: Vector3
@onready var spawn_tmr: Timer = $spawn_tmr
@onready var spawn_min_dist: float = 300.0

func _ready() -> void:
	Globals.connect("level_loaded", get_spawn_data)

# GET SPAWN MARKERS AND REF TO SQUADS NODE -------------------------------------
func get_spawn_data():
	spwn_node = get_tree().get_nodes_in_group("LevelSpawns") #NODE HOLDING SPAWN INFO
	spawner = spwn_node[0]
	squads_node = get_tree().get_nodes_in_group("LevelSquads") #NODE HOSTING SQUADS
	items_node = get_tree().get_first_node_in_group("LevelItems")
	squads = squads_node[0]
	spawn_player()
	
#---------------------- PLAYER SPAWN ------------------------------------------	
func spawn_player():
	var player_spawn_point = spawner.player_spawn
	var player_squad = GlobalsNpc.player_squad.instantiate()
	squads.add_child(player_squad)
	player_squad.position = player_spawn_point.position
	player = get_tree().get_first_node_in_group("Player")
	spawn_tmr.start()
	
func _on_spawn_tmr_timeout() -> void:
	player_pos = player.position
	get_level_spawn_info()

#------------------------------------------------------------------------------
#---------------------- IMMEDIATE SPAWN SPECIAL SQUADS	-------------
func special_spawn_info(special_spawn):
	
	for spawn_node in special_spawn:
		var r1 = spawn_node.min_units
		var r2 = spawn_node.max_units
		mob = randi_range(r1, r2)
		var rdmspn = spawn_node.max_dist
		var spawned_scene = spawn_node.squad_desc.squad_visual
		var squad_equip = spawn_node.squad_desc.squad_equip
		var spawn_point = spawn_node.spawn_loc
		var spawn_id = spawn_node.squad_ID
		spawn_squad(mob, rdmspn, spawned_scene, squad_equip, spawn_point, spawn_id)
		npc_dic[spawn_id] = mob
			
#---------------------- GET ALL NPC SPAWNS FROM LEVEL	--------------
func get_level_spawn_info():
	var spawn_from_level = spawner.lvlallspawn
	
	for spawn_node in spawn_from_level:
		var r1 = spawn_node.min_units
		var r2 = spawn_node.max_units
		mob = randi_range(r1, r2)
		var rdmspn = spawn_node.max_dist
		var spawned_scene = spawn_node.squad_desc.squad_visual
		var squad_equip = spawn_node.squad_desc.squad_equip
		var spawn_point = spawn_node.spawn_loc
		var spawn_id = spawn_node.squad_ID
		if player_pos.distance_to(spawn_point.position) < spawn_min_dist:
			spawn_squad(mob, rdmspn, spawned_scene, squad_equip, spawn_point, spawn_id)
			npc_dic[spawn_id] = mob
			
#-------------------------------------------------------------------------------			
#-------------------------- MAIN SPAWN FUNCTION --------------------------------
func spawn_squad(mob, rdmspn, spawned_scene, squad_equip, spawn_point, spawn_id):
	if !spawned_squads_list.has(spawn_id):
		for i in range(mob):
			var rdmspnx = randf_range(-rdmspn, rdmspn)
			var rdmspnz = randf_range(-rdmspn, rdmspn)
			var npc_squad_unit = spawned_scene.instantiate()
			squads.add_child(npc_squad_unit)
			var character = npc_squad_unit.character_self
			character.char_desc = squad_equip
			character.squad_id = spawn_id
			squads_alive_list.append(str(character.squad_id))
			npc_squad_unit.position = Vector3((spawn_point.position.x + rdmspnx), spawn_point.position.y, (spawn_point.position.z + rdmspnz))
			spawned_squads_list.append(spawn_id)
			#construct squad ref with number of units + spawn_ID / creatre a squad dic or list in NPC manager
			if !spawned_npc_list.has(character):
				spawned_npc_list.append(character)
	else: return
#-------------------------------------------------------------------------------
func spawn_lost_item(item_to_spawn):
	var spawn_item = item_to_spawn.instantiate()
	items_node.add_child(spawn_item)
	spawn_item.position = player_pos + Vector3((randf_range(-0.3, 0.3)),0,-1.0)
