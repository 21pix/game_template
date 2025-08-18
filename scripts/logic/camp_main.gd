extends Area3D

@onready var CampMain: Area3D = $"."
@onready var SitList = []
@onready var CampNPCList = []

var first_init: bool = false
var sit_job1_given: bool = false
var sit_job2_given: bool = false
var sit_job3_given: bool = false


func _on_body_entered(body: Node3D) -> void:
	if !first_init:
		get_sit_list()
		first_init = true
		
	if body.is_in_group("NPC_unit") and body.neutral_state:
		print("npc entered ", self.name)
		CampNPCList.append(body)
		body.start_camp_scheme()
		set_all_sit_jobs()
	else: return

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("NPC_unit"):
		sit_job1_given = false
		sit_job2_given = false
		sit_job3_given = false
		
func get_sit_list():
	var overlaps = CampMain.get_overlapping_areas()
	
	if overlaps.size() > 0:
		for overlap in overlaps:
			if overlap.is_in_group("camp_sit"):
				SitList.append(overlap)
				print(SitList)
					
#--------------------------------------------------
func set_all_sit_jobs():
	if SitList.size() > 0:
		set_sit_job_1()
	if SitList.size() > 1:	
		set_sit_job_2()
	if SitList.size() > 2:
		set_sit_job_3()
	
func set_sit_job_1():
	if !sit_job1_given:
		if CampNPCList.size() > 0:
			var NPC_1 = CampNPCList.get(0)
#			print("NPC_1")
			NPC_1.set_sit_on(SitList[0]) # SENDS SIT POINT [index] AS ARGUMENT WHEN NPC SCRIPT EXECUTES FUNC set_guard_on
		else: return
	sit_job1_given = true

func set_sit_job_2():
	if !sit_job2_given:
		if CampNPCList.size() > 1:
			var NPC_2 = CampNPCList.get(1)
#			print("NPC_2")
			NPC_2.set_sit_on(SitList[1]) # SENDS SIT POINT [index] AS ARGUMENT WHEN NPC SCRIPT EXECUTES FUNC set_guard_on
		else: return
	sit_job2_given = true
	
func set_sit_job_3():
	if !sit_job3_given:
		if CampNPCList.size() > 2:
			var NPC_3 = CampNPCList.get(2)
#			print("NPC_3")
			NPC_3.set_sit_on(SitList[2]) # SENDS SIT POINT [index] AS ARGUMENT WHEN NPC SCRIPT EXECUTES FUNC set_guard_on
		else: return
	sit_job3_given = true
	
