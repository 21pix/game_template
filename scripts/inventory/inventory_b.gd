extends Node
class_name InventoryB

@onready var inventoryb_list: Array
@onready var slots: Array[InventoryBSlot]
@onready var inventory_b: InventoryB = $"."
@onready var player_equipment = get_tree().get_first_node_in_group("player_equipment")
var init_done: bool = false
#@onready var inventory_player: CanvasLayer = $InventoryPlayer

var SLOTB_SCENE = preload("res://assets/scenes/UI/inventory_b_slot.tscn")

func _ready() -> void:
	GlobalsPlayer.connect("inv_b_remove", initialize_inventory)
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
	inventoryb_list = []
	inventoryb_list = GlobalsPlayer.inventory_b_content
	print("inventory b list : ", inventoryb_list)

	for item in inventoryb_list:		
		var slotb = SLOTB_SCENE.instantiate()	
		slotb.get_item_info(item)
		slotb.set_icon()
		inventory_b.add_child(slotb)
			
func add_item(item):
		var slotb = SLOTB_SCENE.instantiate()	
		slotb.get_item_info(item)
		slotb.set_icon()
		inventory_b.add_child(slotb)
