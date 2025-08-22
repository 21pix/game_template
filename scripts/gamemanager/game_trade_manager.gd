extends Node
class_name GameTradeManager

@onready var spawn_actors: GameSpawnActors = $"../spawn_actors"
@onready var trade_list: GametradeList = $trade_list
@onready var player_equipment = get_tree().get_first_node_in_group("player_equipment")
var NPC_trading: Node
var player: Node
var transfered_resource: Resource
var item_to_spawn: PackedScene
var transfered_amount: int
signal trade_received
signal trade_lost

func _ready() -> void:

	GlobalsPlayer.connect("add_object", player_add_object)
	GlobalsPlayer.connect("trader_add_object", trader_add_object)
	GlobalsPlayer.connect("remove_object", drop_item_from_player)
	GlobalsPlayer.connect("transfert_object_to_player", transfert_item_from_chest_to_player)
	GlobalsPlayer.connect("transfert_object_to_trader", transfert_item_from_player_to_chest)
			
#------------------- TRANSFERT FROM PLAYER TO NPC --------------------------------------------------
func transfert_item_from_player_to_npc(item_transfered, amount):
	player = get_tree().get_first_node_in_group("Player")
	NPC_trading = get_tree().get_first_node_in_group("NPC_talking")
	
	for item in player.equip.supplies:
#		print(item.item_name, player.equip.supplies.count(item))
		if item.item_name == item_transfered:
			for n in amount:
				player.equip.supplies.erase(item)
				GlobalsPlayer.emit_signal("inv_p_remove")
				NPC_trading.char_desc.supplies.npc_supplies.append(item)
				player_equipment.update_player_equipment_remove(item)
				
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
				GlobalsPlayer.emit_signal("inv_add", item)
				NPC_trading.char_desc.supplies.npc_supplies.erase(item)		
				player_equipment.update_player_equipment_add(item, amount)		
	trade_received.emit(item_transfered, amount)
		
#--------------------------------- PLAYER RECEIVES REWARD ------------------------------------------
func player_receive_reward(item, amount):
	player = get_tree().get_first_node_in_group("Player")
	for n in amount:
		player.equip.supplies.append(item)
		GlobalsPlayer.emit_signal("inv_add", item)
		player_equipment.update_player_equipment_add(item, amount)	
		
	trade_received.emit(item.item_name, amount)
	
#----------------------------------- PLAYER ADDS OBJECT 
func player_add_object(new_object, amount):
	player = get_tree().get_first_node_in_group("Player")
	for trade_object in trade_list.trade_list:
		if new_object == trade_object.item_name:
			for n in amount:
				player.equip.supplies.append(trade_object)
				GlobalsPlayer.emit_signal("inv_add", trade_object)
#				print("updated supplies : ", player.equip.supplies)
				player_equipment.update_player_equipment_add(trade_object, amount)	# ADD ITEM TO GLOBAL PLAYER EQ LIST	
						
	
#----------------------------------- PLAYER REMOVES OBJECT
func drop_item_from_player(item_removed):
	player = get_tree().get_first_node_in_group("Player")
	
	for item in player.equip.supplies:
		if item.item_name == item_removed:
			player.equip.supplies.erase(item)		
			player_equipment.update_player_equipment_remove(item) # REMOVE ITEM FROM GLOBAL PLAYER EQ LIST
			item_to_spawn = item.spawn_item
			spawn_actors.spawn_lost_item(item_to_spawn)
		

#------------------------------------ TRANSFER ITEM FROM CHEST TO PLAYER
func transfert_item_from_chest_to_player(item_transfered):
	player = get_tree().get_first_node_in_group("Player")
	var chest = get_tree().get_first_node_in_group("active_chest")
	
	for item in chest.chest_content.items:
#		print(item.item_name, NPC_trading.char_desc.supplies.npc_supplies.count(item))
		if item.item_name == item_transfered:
			player.equip.supplies.append(item)
			GlobalsPlayer.emit_signal("inv_add", item)
			chest.chest_content.items.erase(item)
			player_equipment.update_player_equipment_add(item, 1)

#------------------------------------ TRANSFER ITEM FROM PLAYER TO CHEST
func transfert_item_from_player_to_chest_old(item_transfered):
	player = get_tree().get_first_node_in_group("Player")
	var chest = get_tree().get_first_node_in_group("active_chest")
	
	for item in player.equip.supplies:
		if item.item_name == item_transfered:
			player.equip.supplies.erase(item)
			chest.chest_content.items.append(item)
			GlobalsPlayer.emit_signal("inv_p_reset")
			player_equipment.update_player_equipment_remove(item)
			
func transfert_item_from_player_to_chest(item_transfered):
	player = get_tree().get_first_node_in_group("Player")	
	remove_item_from_player_for_trade(item_transfered)
	trader_add_object(item_transfered)

#----------------------------------- PLAYER REMOVES OBJECT FOR TRADE
func remove_item_from_player_for_trade(item_removed):
	player = get_tree().get_first_node_in_group("Player")
	
	for item in player.equip.supplies:
		if item.item_name == item_removed:
			player.equip.supplies.erase(item)		
			player_equipment.update_player_equipment_remove(item) # REMOVE ITEM FROM GLOBAL PLAYER EQ LIST
				
#----------------------------------- TRADER ADDS OBJECT 
func trader_add_object(new_object):
	var chest = get_tree().get_first_node_in_group("active_chest")
	for trade_object in trade_list.trade_list:
		if new_object == trade_object.item_name:
				chest.chest_content.items.append(trade_object)
				GlobalsPlayer.emit_signal("inv_b_add", trade_object)


	
	
