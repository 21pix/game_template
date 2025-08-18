extends Node
class_name NPChealth

@onready var NPC: NPChuman = $"../.."

func _on_head_hitbox_body_part_hit(dam: Variant) -> void:
#	NPC.player_hit_success = true
	NPC.health -= dam*3
	print("NPC.health", NPC.health)
	health_update()

func _on_pelvis_hitbox_body_part_hit(dam: Variant) -> void:
#	NPC.player_hit_success = true
	NPC.health -= dam*0.7
	print("NPC.health", NPC.health)
	health_update()

func _on_rthight_hitbox_body_part_hit(dam: Variant) -> void:
#	NPC.player_hit_success = true
	NPC.health -= dam*0.3
	print("NPC.health", NPC.health)
	health_update()

func _on_lthight_hitbox_body_part_hit(dam: Variant) -> void:
#	NPC.player_hit_success = true
	NPC.health -= dam*0.3
	print("NPC.health", NPC.health)
	health_update()

func _on_torso_hitbox_body_part_hit(dam: Variant) -> void:
#	NPC.player_hit_success = true
	NPC.health -= dam*0.6
	print("NPC.health", NPC.health)
	health_update()

func _on_rarm_hitbox_body_part_hit(dam: Variant) -> void:
#	NPC.player_hit_success = true
	NPC.health -= dam*0.3
	print("NPC.health", NPC.health)
	health_update()
	
func _on_larm_hitbox_body_part_hit(dam: Variant) -> void:
#	NPC.player_hit_success = true
	NPC.health -= dam*0.3
	print("NPC.health", NPC.health)
	health_update()
	
func health_update():
	if NPC.health < 60:
		NPC.cover_defense_on = true
	#	check_cover_distance_()
	if NPC.health <= 0:
		NPC.npc_dead = true
