extends Node2D

@onready var player_weaponcont = get_tree().get_first_node_in_group("weaponcontainer")
@onready var player_equip_full = preload("res://assets/resources/player/player_equip_full.tres")
@onready var player_equip_items = preload("res://assets/resources/player/player_supplies.tres")
@onready var player_weaponset: Array
@onready var player_itemset: Array
@onready var player_inventory_list: Array

func _ready() -> void:
	player_weaponset = player_weaponcont.WeaponSet
	player_itemset = player_equip_items.supplies
	player_inventory_list = player_equip_full.player_stuff # player_stuff = resource list for player inventory objects
	
	player_equip_full.player_stuff.append_array(player_weaponset)
	print(player_equip_full.player_stuff)
	
	player_equip_full.player_stuff.append_array(player_itemset)
	for item in player_inventory_list:
		print(item.inv_name)
