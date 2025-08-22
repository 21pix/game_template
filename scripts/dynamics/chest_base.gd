extends Area3D
class_name Chest

var item_selected: bool = false
@onready var prop_self: Chest = $"."
@export var sound: String
@export var chest_content: Resource



func _on_area_entered(area: Area3D) -> void:
	item_selected = true
	GlobalsPlayer.chest_available = true
	
func _on_area_exited(area: Area3D) -> void:
	item_selected = false
	GlobalsPlayer.chest_available = false
	
func interact(Node):
	if is_instance_valid(prop_self):	
		if item_selected:
			GlobalsPlayer.inventory_b_content = []
			GlobalsPlayer.inventory_b_content.append_array(chest_content.items)
			print("chest content : ",chest_content.items)
			Audio.play(sound)
			
	else:
		return
