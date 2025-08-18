extends Node3D
class_name interior_restrictor

@onready var restrictor_overlap_tmr: Timer = $RestrictorOverlap_tmr
@onready var restrictor_area: Area3D = $RestrictorArea
@onready var interior_npc_list: Array
var first_init: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.8).timeout
#	get_interior_npc_list()
	restrictor_overlap_tmr.start()
	
func get_interior_npc_list():
	var int_overlaps = restrictor_area.get_overlapping_bodies()
	if int_overlaps.size() > 0 :
#		print(int_overlaps)
		for npc in int_overlaps:
			if npc.is_in_group("NPC_unit") and !interior_npc_list.has(npc):
				npc.interior_restrictor_on = true
				interior_npc_list.append(npc)
#				print("interior npc list: ", interior_npc_list)
		first_init = true
		restrictor_overlap_tmr.stop()

func _on_restrictor_overlap_tmr_timeout() -> void:
	if !first_init:
		get_interior_npc_list()

func _on_restrictor_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("NPC_unit"):
		body.interior_restrictor_on = false
