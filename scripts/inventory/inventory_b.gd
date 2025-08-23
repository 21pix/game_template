extends Node
class_name InventoryB

@onready var inventoryb_list: Array
@onready var items_in_inv: Array
@onready var item_amount: int
@onready var slots: Array[InventoryBSlot]
@onready var inventory_b: InventoryB = $"."
@onready var player_equipment = get_tree().get_first_node_in_group("player_equipment")
var init_done: bool = false
#@onready var inventory_player: CanvasLayer = $InventoryPlayer

var SLOTB_SCENE = preload("res://assets/scenes/UI/inventory_b_slot.tscn")

func _ready() -> void:
	GlobalsPlayer.connect("inv_b_remove", initialize_inventory)
	GlobalsPlayer.connect("inv_b_reset", initialize_inventory)
	GlobalsPlayer.connect("inv_b_add", add_item)	

	initialize_inventory()

func initialize_inventory():
	clear_inventory()
	populate_inventory()
	
func clear_inventory():
	var slot_list = inventory_b.get_children()
	for slot in slot_list:
		inventory_b.remove_child(slot)
	
func populate_inventory():
	slots = []
	items_in_inv = []
	inventoryb_list = []
	inventoryb_list = GlobalsPlayer.inventory_b_content
#	print("inventory b list : ", inventoryb_list)

	for item in inventoryb_list:
		add_item(item)
			
func add_item(item):
	var slotb = SLOTB_SCENE.instantiate()
	if !items_in_inv.has(item):
		items_in_inv.append(item)	
		slots.append(slotb)
		slotb.get_item_info(item)
		slotb.set_icon()
		inventory_b.add_child(slotb)
		
	elif items_in_inv.has(item):
		item_amount = inventoryb_list.count(item)
		for slot in slots:
			if slot.slotname == item.item_name :
				print(item.inv_name," ", "amount : ", item_amount)
				slot.set_quantity(item_amount)
				
