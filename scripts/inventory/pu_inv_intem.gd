extends Area3D

class_name inv_item

var item_name = "Purple Key"
var type = ""
var descr = ""


@onready var key_item: Area3D = $"."

var item_selected: bool = false

func _ready() -> void:
	pass
#
func _on_area_entered(area: Area3D) -> void:
	item_selected = true

func _on_area_exited(area: Area3D) -> void:
	item_selected = false
		
func interact(Node):
	if is_instance_valid(key_item):
		if item_selected:
			Globals.get_info.emit()
			print("item picked")
			Audio.play("sounds/Pickups/collect.ogg")
			key_item.queue_free()	
	else:
		return
