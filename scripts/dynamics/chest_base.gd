extends Area3D
class_name Chest

var item_selected: bool = false
@onready var prop_self: Chest = $"."
@export var sound: String
@export var chest_content: Resource



func _on_area_entered(area: Area3D) -> void:

	GlobalsPlayer.chest_available = true
	
func _on_area_exited(area: Area3D) -> void:

	GlobalsPlayer.chest_available = false
	
func interact(Node):
	if is_instance_valid(prop_self):	
		if GlobalsPlayer.chest_available:
			prop_self.add_to_group("active_chest")
			GlobalsPlayer.inventory_b_content = []
			GlobalsPlayer.inventory_b_content.append_array(chest_content.items)
			Audio.play(sound)
		else:
			prop_self.remove_from_group("active_chest")
	else:
		return
