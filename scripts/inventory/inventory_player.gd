extends Node
class_name Inventory

@onready var player_inventory_list: Array
@onready var items_in_inv: Array
@onready var item_amount: int
@onready var slots: Array[InventorySlot]
@onready var inventory: Inventory = $"."
@onready var player_equipment = get_tree().get_first_node_in_group("player_equipment")
#@onready var inventory_player: CanvasLayer = $InventoryPlayer

var SLOT_SCENE = preload("res://assets/scenes/UI/inventory_slot.tscn")

func _ready() -> void:
	GlobalsPlayer.connect("inv_add", add_item)
	GlobalsPlayer.connect("inv_p_reset", initialize_inventory)
	player_equipment.init_player_equipment()
	player_inventory_list = GlobalsPlayer.player_equip_full # player_stuff = resource list for player inventory objects

	initialize_inventory()

func initialize_inventory():
	clear_inventory()
	populate_inventory()

func populate_inventory():
	slots = []
	items_in_inv = []
	player_inventory_list = []
	player_inventory_list = GlobalsPlayer.player_equip_full
#	print("inventory b list : ", inventoryb_list)

	for item in player_inventory_list:
		add_item(item)
		
func clear_inventory():
	for n in inventory.get_children():
		inventory.remove_child(n)
		n.queue_free() 
			
func add_item(item):
		var slot = SLOT_SCENE.instantiate()	
		slot.get_item_info(item)
		slot.set_icon()
		inventory.add_child(slot)
