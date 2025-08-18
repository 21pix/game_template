extends Node
class_name GameRelations

@onready var f1_list: Array
@onready var f2_list: Array
@onready var relations_tmr_1: Timer = $timers/relations_tmr1
@onready var player: CharacterBody3D

func _ready() -> void:
	Globals.connect("level_loaded", get_faction1_list)
	GlobalsPlayer.connect("player_friend_to_f1", set_player_friend_to_f1)
	GlobalsPlayer.connect("player_neutral_to_f1", set_player_neutral_to_f1)
	GlobalsPlayer.connect("player_enemy_to_f1", set_player_enemy_to_f1)
	GlobalsPlayer.connect("player_friend_to_f2", set_player_friend_to_f2)
	GlobalsPlayer.connect("player_neutral_to_f2", set_player_neutral_to_f2)
	GlobalsPlayer.connect("player_enemy_to_f2", set_player_enemy_to_f2)
	Dialogic.signal_event.connect(_set_player_status)

#-------------------------------------------------------------------------------
#----------------- PLAYER vs NPC RELATION --------------------------------------
	
func _set_player_status(argument:String): #Changing status from dialogues
	player = get_tree().get_first_node_in_group("Player")
	if argument == "player_hostile_to_f1":
		set_player_neutral_to_f1()	
		
	if argument == "player_enemy_to_f1":
		set_player_enemy_to_f1()
			
#--------------------- FACTION 1 --------------------
func set_player_friend_to_f1():
	player = get_tree().get_first_node_in_group("Player")
	player.remove_from_group("PlayerHostile_to_f1")
	player.remove_from_group("PlayerEnemy_to_f1")
	player.add_to_group("PlayerFriend_to_f1")

func set_player_neutral_to_f1():
	player = get_tree().get_first_node_in_group("Player")
	player.remove_from_group("PlayerFriend_to_f1")
	player.remove_from_group("PlayerEnemy_to_f1")
	player.add_to_group("PlayerHostile_to_f1")

func set_player_enemy_to_f1():
	player = get_tree().get_first_node_in_group("Player")
	player.remove_from_group("PlayerHostile_to_f1")
	player.remove_from_group("PlayerFriend_to_f1")
	player.add_to_group("PlayerEnemy_to_f1")

#--------------------- FACTION 2 --------------------
func set_player_friend_to_f2():
	player = get_tree().get_first_node_in_group("Player")
	player.remove_from_group("PlayerHostile_to_f2")
	player.remove_from_group("PlayerEnemy_to_f2")
	player.add_to_group("PlayerFriend_to_f2")

func set_player_neutral_to_f2():
	player = get_tree().get_first_node_in_group("Player")
	player.remove_from_group("PlayerFriend_to_f2")
	player.remove_from_group("PlayerEnemy_to_f2")
	player.add_to_group("PlayerHostile_to_f2")

func set_player_enemy_to_f2():
	player = get_tree().get_first_node_in_group("Player")
	player.remove_from_group("PlayerHostile_to_f2")
	player.remove_from_group("PlayerFriend_to_f2")
	player.add_to_group("PlayerEnemy_to_f2")
	
#------------------------------------------------------------------------------
#-------------------- NPC RELATIONS -------------------------------------------
	
func get_faction1_list():

	relations_tmr_1.start(3.0)
	
func _on_relations_tmr_1_timeout() -> void:
	f1_list = get_tree().get_nodes_in_group("faction_1")
	f2_list = get_tree().get_nodes_in_group("faction_2")
	print("faction_1", f1_list)
	print("faction_2", f2_list)
	print("relations updated")
	set_relation_status_f1vsf2()

func set_relation_status_f1vsf2():
	for npc in f1_list:
		npc.add_to_group("enemy_to_F2")
	for npc in f2_list:
		npc.add_to_group("enemy_to_F1")
