extends Area3D

class_name item_health

@onready var health_item: Area3D = $"."

var item_selected: bool = false

func _ready() -> void:
	pass
#
func _on_area_entered(area: Area3D) -> void:
	item_selected = true

func _on_area_exited(area: Area3D) -> void:
	item_selected = false
		
func interact(Node):
	if is_instance_valid(health_item):
		if item_selected:
			Globals.add_health.emit()
			Audio.play("sounds/Pickups/collect.ogg")
			health_item.queue_free()	
	else:
		return
