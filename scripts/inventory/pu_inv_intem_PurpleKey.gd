extends Area3D

class_name inv_item_purplekey

var item_name = "Purple Key"
var type = ""
var descr = ""


@onready var purplekey: inv_item_purplekey = $"."

var item_selected: bool = false

func _ready() -> void:
	pass
#
func _on_area_entered(area: Area3D) -> void:
	item_selected = true

func _on_area_exited(area: Area3D) -> void:
	item_selected = false
		
func interact(Node):
	if is_instance_valid(purplekey):
		if item_selected:
			Globals.found_purplekey.emit()
			Audio.play("sounds/Pickups/collect.ogg")
			purplekey.queue_free()	
	else:
		return
