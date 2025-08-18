extends Node
class_name NPCutilMeetPlayer

@onready var NPC: NPChuman = $"../.."

func _on_meet_overlap_area_entered(area: Area3D) -> void:
	NPC.meet_friend_dist_on = true

func _on_meet_overlap_area_exited(area: Area3D) -> void:
	NPC.meet_friend_dist_on = false
