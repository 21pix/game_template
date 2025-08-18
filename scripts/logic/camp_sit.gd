extends Area3D
@onready var camp_sit: Area3D = $"."
@export_enum("normal", "low") var sit_position : String


func _on_body_entered(body: Node3D) -> void:
	var overlaps = camp_sit.get_overlapping_bodies() #VISION TRIGGER
	
	if overlaps.size() > 1:
		return
	else:			
		if body.is_in_group("NPC_unit"):
			print("NPC Sit")
			remove_from_group("camp_sit")
			
		else: return



func _on_body_exited(body: Node3D) -> void:
	var overlaps = camp_sit.get_overlapping_bodies() #VISION TRIGGER
	
	if overlaps.size() > 1:
		return
	else:
		if body.is_in_group("NPC_unit"):
			print("NPC Up")
			add_to_group("camp_sit")
		else: return
