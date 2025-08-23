extends Node
class_name InventorySlot

@onready var hosted_item: Resource
@onready var icon: Texture2D
@onready var child_item_name: String
@onready var button: Button = $Button
@onready var slotname: String
@onready var inventory_slot: InventorySlot = $"."
@onready var inventory_b = get_tree().get_first_node_in_group("inventory_b")

func _ready() -> void:
	button.pressed.connect(button_action)
#-------------------- ON SLOT SPAWN			
func get_item_info(item):
	child_item_name = item.item_name
	icon = item.inv_icon
	slotname = item.item_name
	hosted_item = item
	
func set_icon():
	$Icon.texture = icon
#--------------------------------

func set_quantity(item_amount):
	$Amount.text = str(item_amount)

func button_action():
	if !GlobalsPlayer.inventory_b_on:
		GlobalsPlayer.remove_object.emit(child_item_name)
		GlobalsPlayer.remove_slot.emit(inventory_slot, hosted_item)
		
	if GlobalsPlayer.inventory_b_on:
		GlobalsPlayer.transfert_object_to_trader.emit(child_item_name)
		inventory_b.initialize_inventory()
		inventory_slot.queue_free()

func delete_slot():
	inventory_slot.queue_free()
