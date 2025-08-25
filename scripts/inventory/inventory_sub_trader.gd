extends Node
class_name InventorySub_trader

@onready var trader_inventory_list: Array

@onready var items_in_inv: Array
@onready var item_amount: int
@onready var slots: Array[InventorySlotTrader]

@onready var inventory_trader = get_tree().get_first_node_in_group("inventory_trader")

#@onready var inventory_player: CanvasLayer = $InventoryPlayer

var SLOT_SCENE = preload("res://assets/scenes/UI/inventory_trader_slot.tscn")

func _ready() -> void:
	GlobalsPlayer.connect("inventory_trader_reset", initialize_inventory)
	GlobalsPlayer.connect("remove_slot", remove_item)

func initialize_inventory():
	clear_inventory()
	populate_list()
	
func clear_inventory():
	for n in inventory_trader.get_children():
		inventory_trader.remove_child(n)
		n.queue_free()	
	
func populate_list():
	slots = []
	items_in_inv = []	
	trader_inventory_list = []
	trader_inventory_list = GlobalsPlayer.inventory_trader_content
	print("trader inventory list : ", trader_inventory_list)
	populate_inventory()
	
func populate_inventory():
	
	for item in trader_inventory_list:
		add_item(inventory_trader, item, trader_inventory_list)

func add_item(inventory, item, inventory_list):
	print("add item started")
	var slot = SLOT_SCENE.instantiate()	
	if !items_in_inv.has(item):
		items_in_inv.append(item)	
		slots.append(slot)
		slot.get_item_info(item)
		slot.set_icon()
		inventory.add_child(slot)
		
	elif items_in_inv.has(item):
		item_amount = inventory_list.count(item)
		for storedslot in slots:
			if storedslot.slotname == item.item_name :
				print(item.inv_name," ", "amount : ", item_amount)
				storedslot.set_quantity(item_amount)

func remove_item(slot_selected, item):
	if items_in_inv.count(item) == 1:
		slot_selected.delete_slot()	
	
	elif items_in_inv.count(item) >= 2:
		item_amount = trader_inventory_list.count(item)
		for slot in slots:
			if slot.slotname == item.item_name :
				print(item.inv_name," ", "amount : ", item_amount)
				slot.set_quantity(item_amount)
				
