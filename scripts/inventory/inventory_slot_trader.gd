extends Node
class_name InventorySlotTrader

@onready var icon: Texture2D
@onready var child_item_name: String
@onready var slotname: String
@onready var button: Button = $Button
@onready var inventory_trader_slot: InventorySlotTrader = $"."
@onready var inventory_trader = get_tree().get_first_node_in_group("inventory_trader")
@onready var inventory_player = get_tree().get_first_node_in_group("inventory_player")
@onready var player_inventory_list = GlobalsPlayer.player_equip_full
@onready var trader_inventory_list = GlobalsPlayer.inventory_trader_content

func _ready() -> void:
	button.pressed.connect(button_action)
	
func button_action():
	GlobalsPlayer.transfert_item.emit(trader_inventory_list, player_inventory_list, child_item_name, "inventory_trader_reset", "inventory_player_reset")
	delete_slot()
	
func delete_slot():
	inventory_trader_slot.queue_free()
		
func get_item_info(item):
	child_item_name = item.item_name
	icon = item.inv_icon
	slotname = item.item_name
	
func set_icon():
	$Icon.texture = icon

func set_quantity(item_amount):
	$Amount.text = str(item_amount)
