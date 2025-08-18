extends Area3D
class_name ItemWater

@onready var object_water: Area3D = $"."

var item_selected: bool = false


func _on_area_entered(area: Area3D) -> void:
	item_selected = true

func _on_area_exited(area: Area3D) -> void:
	item_selected = false
		
func interact(Node):
	if is_instance_valid(object_water):
		if item_selected:
			GlobalsPlayer.add_object.emit("water", 1)
			Audio.play("sounds/Pickups/collect.ogg")
			object_water.queue_free()	
	else:
		return
