extends Node
class_name GameTradeManager

@onready var trade_list: GametradeList = $trade_list

var NPC_trading: Node
var player: Node
var transfered_resource: Resource
var transfered_amount: int
signal trade_received
signal trade_lost

func _ready() -> void:

	GlobalsPlayer.connect("add_object", player_add_object)
	

#-------------------------------------------- TEST INPUT

		
#------------------- TRANSFERT FROM PLAYER TO NPC --------------------------------------------------
func transfert_item_from_player_to_npc(item_transfered, amount):
	player = get_tree().get_first_node_in_group("Player")
	NPC_trading = get_tree().get_first_node_in_group("NPC_talking")
	
	for item in player.equip.supplies:
#		print(item.item_name, player.equip.supplies.count(item))
		if item.item_name == item_transfered:
			for n in amount:
				player.equip.supplies.erase(item)
				NPC_trading.char_desc.supplies.npc_supplies.append(item)
				
	trade_lost.emit(item_transfered, amount)
	
#---------------------------------- TRANSFERT FROM NPC TO PLAYER -----------------------------------				
func transfert_item_from_npc_to_player(item_transfered, amount):
	player = get_tree().get_first_node_in_group("Player")
	NPC_trading = get_tree().get_first_node_in_group("NPC_talking")
	
	for item in NPC_trading.char_desc.supplies.npc_supplies:
#		print(item.item_name, NPC_trading.char_desc.supplies.npc_supplies.count(item))
		if item.item_name == item_transfered:
			for n in amount:
				player.equip.supplies.append(item)
				NPC_trading.char_desc.supplies.npc_supplies.erase(item)				
	trade_received.emit(item_transfered, amount)
	
#--------------------------------- PLAYER RECEIVES REWARD ------------------------------------------
func player_receive_reward(item, amount):
	player = get_tree().get_first_node_in_group("Player")
	for n in amount:
		player.equip.supplies.append(item)
	
	trade_received.emit(item.item_name, amount)
	
#----------------------------------- PLAYER ADDS OBJECT 
func player_add_object(new_object, amount):
	player = get_tree().get_first_node_in_group("Player")
	for trade_object in trade_list.trade_list:
		if new_object == trade_object.item_name:
			for n in amount:
				player.equip.supplies.append(trade_object)
#				print("trade_object : ", trade_object.item_name)
				print("added supply : ", trade_object.item_name, player.equip.supplies.count(trade_object))
				print("updated supplies : ", player.equip.supplies)
				
#----------------------------------- PLAYER REMOVES OBJECT
func remove_item_from_player(item_removed, amount):
	player = get_tree().get_first_node_in_group("Player")
	
	for item in player.equip.supplies:
#		print(item.item_name, player.equip.supplies.count(item))
		if item.item_name == item_removed:
			for n in amount:
				player.equip.supplies.erase(item)
				NPC_trading.char_desc.supplies.npc_supplies.append(item)			
