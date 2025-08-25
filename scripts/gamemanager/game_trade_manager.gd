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
var receiver: Array
signal trade_received
signal trade_lost

func _ready() -> void:

	GlobalsPlayer.connect("add_object", player_add_object)
	GlobalsPlayer.connect("trader_add_object", trader_add_object)
	GlobalsPlayer.connect("player_remove_object", player_drop_item)
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
				GlobalsPlayer.emit_signal("inv_p_reset", item)
				NPC_trading.char_desc.supplies.npc_supplies.erase(item)		
				player_equipment.update_player_equipment_add(item, amount)		
	trade_received.emit(item_transfered, amount)
		
#--------------------------------- PLAYER RECEIVES REWARD ------------------------------------------
func player_receive_reward(item, amount):
	player = get_tree().get_first_node_in_group("Player")
	for n in amount:
		player.equip.supplies.append(item)
		GlobalsPlayer.emit_signal("inv_p_reset", item)
		player_equipment.update_player_equipment_add(item, amount)	
		
	trade_received.emit(item.item_name, amount)

#------------------------------------ TRANSFER ITEM FROM CHEST TO PLAYER
func transfert_item_from_chest_to_player(item_transfered):
	remove_item_from_chest(item_transfered)
	player_add_object(item_transfered, 1)
	
#------------------------------------ REMOVE ITEM FROM TRADER
func remove_item_from_chest(item_removed):
	var chest = get_tree().get_first_node_in_group("active_chest")	
	for item in chest.chest_content.items:
		if item.item_name == item_removed:		
			chest.chest_content.items.erase(item)
			GlobalsPlayer.inventory_b_content.erase(item)
			GlobalsPlayer.emit_signal("inv_b_reset")

#------------------------------------ TRANSFER ITEM FROM PLAYER TO CHEST			
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
			GlobalsPlayer.player_equip_full.erase(item)
			player_equipment.update_player_equipment_remove(item) # REMOVE ITEM FROM GLOBAL PLAYER EQ LIST
			GlobalsPlayer.emit_signal("inv_b_reset")
				
#----------------------------------- TRADER ADDS OBJECT 
func trader_add_object(new_object):
	var chest = get_tree().get_first_node_in_group("active_chest")
	for trade_object in trade_list.trade_list:
		if new_object == trade_object.item_name:
			chest.chest_content.items.append(trade_object)
			GlobalsPlayer.inventory_b_content.append(trade_object)
			GlobalsPlayer.emit_signal("inv_b_reset")
			
#----------------------------------- PLAYER ADDS OBJECT 
func player_add_object(new_item, amount):
	receiver = GlobalsPlayer.player_equip_full
	var inventory_reset = "inventory_player_reset"
	receiver_add_item(receiver, new_item, amount, inventory_reset)
					
#----------------------------------- ADD ITEM GENERIC	
func receiver_add_item(receiver, new_item, amount, inventory_reset):
	for n in amount :
		for trade_object in trade_list.trade_list:
			if new_item == trade_object.item_name:
				receiver.append(trade_object) # RECEIVER SUPPLIES LIST
				GlobalsPlayer.emit_signal(inventory_reset)

#----------------------------------- REMOVE ITEM GENERIC
func owner_remove_item(owner, lost_item, inventory_reset):
	for item in owner:
		if item.item_name == lost_item:
			owner.erase(item)	
			GlobalsPlayer.emit_signal(inventory_reset)

#----------------------------------- TRANSFER ITEM GENERIC
func transfert_item_generic(owner, receiver, trade_item, inventory_reset):
	owner_remove_item(owner, trade_item, inventory_reset)
	receiver_add_item(receiver, trade_item, 1, inventory_reset)

# --------------------------------- PLAYER DROP ITEM
func player_drop_item(lost_item):
	var owner = GlobalsPlayer.player_equip_full
	var inventory_reset = "inventory_player_reset"
	drop_item_generic(owner, lost_item, inventory_reset)
	
#---------------------------------- DROP ITEM GENERIC
func drop_item_generic(owner, lost_item, inventory_reset):
	for item in owner:
		if item.item_name == lost_item:
			owner.erase(item)	
			GlobalsPlayer.emit_signal(inventory_reset)
			item_to_spawn = item.spawn_item
			spawn_actors.spawn_lost_item(item_to_spawn)
