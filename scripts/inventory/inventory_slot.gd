extends Node
class_name InventorySlot

@onready var icon: Texture2D
@onready var child_item_name: String
@onready var button: Button = $Button
@onready var slotname: String
@onready var inventory_slot: InventorySlot = $"."
@onready var inventory_b = get_tree().get_first_node_in_group("inventory_b")

func _ready() -> void:
	button.pressed.connect(button_action)
	
func button_action():
	if !GlobalsPlayer.inventory_b_on:
		GlobalsPlayer.remove_object.emit(child_item_name)
		inventory_slot.queue_free()
		
	if GlobalsPlayer.inventory_b_on:
		GlobalsPlayer.transfert_object_to_trader.emit(child_item_name)
		inventory_slot.queue_free()
		inventory_b.initialize_inventory()
	
func get_item_info(item):
	child_item_name = item.item_name
	icon = item.inv_icon
	slotname = item.item_name
	
func set_icon():
	$Icon.texture = icon

func set_quantity(item_amount):
	$Amount.text = str(item_amount)
