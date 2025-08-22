extends Node
class_name AutoloadPlayer

# RELATIONS
signal player_friend_to_f1
signal player_neutral_to_f1
signal player_enemy_to_f1
signal player_friend_to_f2
signal player_neutral_to_f2
signal player_enemy_to_f2

# TRADE - TRANSFERT
signal add_object(object, amount)
signal trader_add_object(object)
signal remove_object(object)
signal transfert_object_to_player(object)
signal transfert_object_to_trader(object)
signal inv_add
signal inv_b_add
signal inv_p_remove
signal inv_b_remove
signal inv_p_reset

# EQUIPMENT
var player_equip_full: Array
var player_equip_items = load("res://assets/resources/player/player_supplies.tres")

# INVENTORY
var inventory_on: bool
var inventory_b_on: bool
var inventory_b_content: Array[Resource]
var chest_available: bool
