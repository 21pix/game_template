extends Node
class_name InventorySlot

@onready var icon: Texture2D
@onready var child_item_name: String
@onready var button: Button = $Button
@onready var inventory_slot: InventorySlot = $"."

func _ready() -> void:
	button.pressed.connect(button_action)
	
func button_action():
	print("hosted item name : ", child_item_name)
	GlobalsPlayer.remove_object.emit(child_item_name)
#	print(child_item_name)
	inventory_slot.queue_free()
	
func get_item_info(item):
	child_item_name = item.item_name
	icon = item.inv_icon

func set_icon():
	$Icon.texture = icon
