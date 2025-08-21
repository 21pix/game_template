extends Node
class_name InventorySlot

@onready var icon: Texture2D
@onready var iname_temp = ""
@onready var button: Button = $Button
@onready var inventory_slot: InventorySlot = $"."

func _ready() -> void:
	button.pressed.connect(button_action)
	
func button_action():
	print("item clicked")
	GlobalsPlayer.remove_object.emit("medkit", 1)
	inventory_slot.queue_free()
	
func get_item_info(item):
	icon = item.inv_icon

func set_icon():
	$Icon.texture = icon
