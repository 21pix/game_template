extends Node
class_name InventoryBSlot

@onready var icon: Texture2D
@onready var child_item_name: String
@onready var button: Button = $Button
@onready var inventory_b_slot: InventoryBSlot = $"."

func _ready() -> void:
	button.pressed.connect(button_action)
	
func button_action():
	GlobalsPlayer.transfert_object_to_player.emit(child_item_name)
	GlobalsPlayer.trader_add_object.emit(child_item_name)
	inventory_b_slot.queue_free()
	
func get_item_info(item):
	child_item_name = item.item_name
	icon = item.inv_icon

func set_icon():
	$Icon.texture = icon
