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
signal remove_object(object)
signal inv_add
signal inv_remove
# INVENTORY
var inventory_on: bool
