extends Node
class_name InventoryB

@onready var inventoryb_list: Array
@onready var slots: Array[InventorySlot]
@onready var inventory_b: InventoryB = $"."
@onready var player_equipment = get_tree().get_first_node_in_group("player_equipment")
#@onready var inventory_player: CanvasLayer = $InventoryPlayer

var SLOT_SCENE = preload("res://assets/scenes/UI/inventory_slot.tscn")

func _ready() -> void:
#--------- GET ITEMS FROM GENERATOR 
	GlobalsPlayer.connect("inv_add", add_item)
	GlobalsPlayer.connect("inv_remove", initialize_inventory)
	
	inventoryb_list = GlobalsPlayer.chest_content # GET LIST FROM CHEST RESOURCE
#---------------
	
	initialize_inventory()

func initialize_inventory():
#	clear_inventory()
	for item in inventoryb_list:		
		var slot = SLOT_SCENE.instantiate()	
		slot.get_item_info(item)
		slot.set_icon()
		inventory_b.add_child(slot)

func clear_inventory():
	for n in inventory_b.get_children():
		inventory_b.remove_child(n)
		n.queue_free() 
			
func add_item(item):
		var slot = SLOT_SCENE.instantiate()	
		slot.get_item_info(item)
		slot.set_icon()
		inventory_b.add_child(slot)
