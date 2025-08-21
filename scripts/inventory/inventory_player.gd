extends Node
class_name Inventory

@onready var player_weaponcont = get_tree().get_first_node_in_group("weaponcontainer")
@onready var player_equip_full = preload("res://assets/resources/player/player_equip_full.tres")
@onready var player_equip_items = preload("res://assets/resources/player/player_supplies.tres")
@onready var player_weaponset: Array
@onready var player_itemset: Array
@onready var player_inventory_list: Array
@onready var slots: Array[InventorySlot]
@onready var inventory: Inventory = $"."
#@onready var inventory_player: CanvasLayer = $InventoryPlayer




var SLOT_SCENE = preload("res://assets/scenes/UI/inventory_slot.tscn")

func _ready() -> void:
#--------- GET ALL ITEMS FROM PLAYER 
	GlobalsPlayer.connect("inv_add", add_item)
	GlobalsPlayer.connect("inv_remove", initialize_inventory)
	
	player_weaponset = player_weaponcont.WeaponSet
	player_itemset = player_equip_items.supplies
	player_inventory_list = player_equip_full.player_stuff # player_stuff = resource list for player inventory objects
	
	player_equip_full.player_stuff.append_array(player_weaponset)
	print(player_equip_full.player_stuff)
	
	player_equip_full.player_stuff.append_array(player_itemset)
#---------------
	
	initialize_inventory()

func initialize_inventory():
#	clear_inventory()
	for item in player_inventory_list:		
		var slot = SLOT_SCENE.instantiate()	
		slot.get_item_info(item)
		slot.set_icon()
		inventory.add_child(slot)

func clear_inventory():
	for n in inventory.get_children():
		inventory.remove_child(n)
		n.queue_free() 
			
func add_item(item):
		var slot = SLOT_SCENE.instantiate()	
		slot.get_item_info(item)
		slot.set_icon()
		inventory.add_child(slot)
		
