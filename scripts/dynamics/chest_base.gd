extends Area3D
class_name Chest

var item_selected: bool = false
@onready var prop_self: Chest = $"."
@export var sound: String
@export var chest_content: Resource



func _on_area_entered(area: Area3D) -> void:
	item_selected = true

func _on_area_exited(area: Area3D) -> void:
	item_selected = false

func interact(Node):
	if is_instance_valid(prop_self):
		if item_selected:
			GlobalsPlayer.inventory_b_on = true
			GlobalsPlayer.chest_content = chest_content.items
			Audio.play(sound)
			
	else:
		GlobalsPlayer.inventory_b = false
		return
