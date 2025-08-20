extends Node2D

@onready var player_weaponcont = get_tree().get_first_node_in_group("weaponcontainer")
@onready var player_equip_full = preload("res://assets/resources/player/player_equip_full.tres")
@onready var player_equip_items = preload("res://assets/resources/player/player_supplies.tres")
@onready var player_weaponset: Array
@onready var player_itemset: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	player_weaponset = player_weaponcont.WeaponSet
	player_itemset = player_equip_items.supplies
	
	player_equip_full.player_stuff.append_array(player_weaponset)
	print(player_equip_full.player_stuff)
	
	player_equip_full.player_stuff.append_array(player_itemset)
	print(player_equip_full.player_stuff)
