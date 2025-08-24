extends Inventorymain
class_name InventorySub

@onready var player_inventory_list: Array
@onready var items_in_inv: Array
@onready var item_amount: int
@onready var slots: Array[InventorySlot]
@onready var inventory: Inventory = $"."
@onready var player_equipment = get_tree().get_first_node_in_group("player_equipment")
#@onready var inventory_player: CanvasLayer = $InventoryPlayer

var SLOT_SCENE = preload("res://assets/scenes/UI/inventory_slot.tscn")

func _ready() -> void:
	player_equipment.init_player_equipment()
	GlobalsPlayer.connect("inv_p_reset", initialize_inventory)
	GlobalsPlayer.connect("remove_slot", remove_item)
	initialize_inventory()

func initialize_inventory():
	clear_inventory()
	populate_inventory()

func populate_inventory():
	slots = []
	items_in_inv = []
	player_inventory_list = []
	player_inventory_list = GlobalsPlayer.player_equip_full
	print("player inventory list : ", player_inventory_list)

	for item in player_inventory_list:
		add_item(item)
		
func clear_inventory():
	for n in inventory.get_children():
		inventory.remove_child(n)
		n.queue_free() 

func add_item(item):
	var slot = SLOT_SCENE.instantiate()	
	if !items_in_inv.has(item):
		items_in_inv.append(item)	
		slots.append(slot)
		slot.get_item_info(item)
		slot.set_icon()
		inventory.add_child(slot)
		
	elif items_in_inv.has(item):
		item_amount = player_inventory_list.count(item)
		for playerslot in slots:
			if playerslot.slotname == item.item_name :
				print(item.inv_name," ", "amount : ", item_amount)
				playerslot.set_quantity(item_amount)

func remove_item(slot_selected, item):
	if items_in_inv.count(item) == 1:
		slot_selected.delete_slot()	
	
	elif items_in_inv.count(item) >= 2:
		item_amount = player_inventory_list.count(item)
		for slot in slots:
			if slot.slotname == item.item_name :
				print(item.inv_name," ", "amount : ", item_amount)
				slot.set_quantity(item_amount)
				
