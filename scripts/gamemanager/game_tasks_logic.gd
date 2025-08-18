extends Node
class_name GameTasksLogic

@onready var npc_manager: GameNPCManager = $"../../npc_manager"
@onready var spawn_actors: GameSpawnActors = $"../../spawn_actors"
@onready var trade_manager: GameTradeManager = $"../../trade_manager"
@onready var tasks_list: GameTasksList = $"../tasks_list"
@onready var trade_list: GametradeList = $"../../trade_manager/trade_list"

signal task_executed

func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal_joe)
	Dialogic.signal_event.connect(_on_dialogic_signal_mouse)
	
# -----------------------  TEST TASKS

# ---- JOE TASK 1

func _on_dialogic_signal_joe(argument:String):
	if argument == "joe_task1_started_logic":	
		target_spawn()
	if argument == "joe_send_reward":
		transfert_reward_to_player(trade_list.medkit, 2)	
			
func target_spawn():
	var spwn_node = get_tree().get_nodes_in_group("LevelSpawns")
	var spawner = spwn_node[0]
	var special_spawn = spawner.a2_s1spawn
	spawn_actors.special_spawn_info(special_spawn)
	check_target_life()
				
func check_target_life():		
		var timer = Timer.new()
		add_child(timer)
		timer.wait_time = 2.0
		timer.one_shot = false
		timer.start()
		timer.timeout.connect(_on_check_target_life_timer_timeout)
				
func _on_check_target_life_timer_timeout():
#	print("squads list : ", npc_manager.squads_active_list)
	if !npc_manager.squads_active_list.has("a2_s1_faction2_group1"):
		GlobalsGameManager.joe_task1_executed = true

# ---- MOUSE TASK
func _on_dialogic_signal_mouse(argument:String):
	var object = tasks_list.mouse_task["object_needed"]
	var amount = tasks_list.mouse_task["amount"]
	var ID = tasks_list.mouse_task["ID"]
	if argument == "check_player_object":
		check_player_has_fetched_object(object, amount, ID)

#---- GIVE ITEMS
	if argument == "mouse_get_items":
		transfert_object_to_npc("medkit", 3)
#---- MOUSE REWARD
	if argument == "mouse_send_reward":
		transfert_reward_to_player(trade_list.water, 2)			

#-----------------------------------------------------------------
func check_player_has_fetched_object(object, amount, ID):
	var player = get_tree().get_first_node_in_group("Player")
	for supply in player.equip.supplies:
		if supply.item_name == object:	
			if player.equip.supplies.count(supply) >= amount:
				task_executed.emit(ID)

func _on_task_executed(ID) -> void:
	for task in tasks_list.game_tasks:
		if ID == task.ID:
			GlobalsGameManager.set(str(ID)+"_executed", true)
	print("task executed status : ",GlobalsGameManager.mouse_task_executed)
			
#---------------- PLAYER REWARD ----------------------------------
func transfert_reward_to_player(Resource, Int):
	trade_manager.player_receive_reward(Resource, Int)
	
#---------------- GIVE OBJECT to NPC  ----------------------------------
func transfert_object_to_npc(String, Int):
	trade_manager.transfert_item_from_player_to_npc(String, Int)
