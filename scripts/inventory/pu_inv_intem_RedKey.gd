extends Area3D

class_name inv_item_Redkey

var item_name = "Red Key"
var type = ""
var descr = ""

@onready var red_key: inv_item_Redkey = $"."


var item_selected: bool = false

func _ready() -> void:
	pass
#
func _on_area_entered(area: Area3D) -> void:
	item_selected = true

func _on_area_exited(area: Area3D) -> void:
	item_selected = false
		
func interact(Node):
	if is_instance_valid(red_key):
		if item_selected:
			Globals.found_redkey.emit()
			Audio.play("sounds/Pickups/collect.ogg")
			red_key.queue_free()	
	else:
		return
