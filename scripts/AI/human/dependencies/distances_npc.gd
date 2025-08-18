extends Node
class_name NPCutilDistancesNPC

@onready var vsnpc_distances_tmr: Timer = $"../../TIMERS/VSNPC_Distances_tmr"
@onready var NPC: NPChuman = $"../.."

func _ready() -> void:
	pass # Replace with function body.


func start_dist_calc_delayed_npc():
	await get_tree().create_timer(0.2).timeout
	vsnpc_distances_tmr.start(0.1)

func stop_dist_calc_npc():
	vsnpc_distances_tmr.stop()

func _on_vsnpc_distances_tmr_timeout() -> void:
	if NPC.enemy_npc:
		var enemy_pos = NPC.enemy_npc.position 
		var npc_pos = NPC.position
		NPC.dist_to_target_npc = enemy_pos.distance_to(npc_pos)
	else: return
