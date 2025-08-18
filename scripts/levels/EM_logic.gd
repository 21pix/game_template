extends Node
@onready var em_patrol_3: Marker3D = $"../Camps/EM_patrol3"
@onready var em_patrol_2: Marker3D = $"../Camps/EM_patrol2"
@onready var em_patrol_1: Marker3D = $"../Camps/EM_patrol1"
@onready var em_guard_1: Marker3D = $"../Camps/EM_guard1"
@onready var em_guard_2: Marker3D = $"../Camps/EM_guard2"



@onready var squads: Node = $Squads

@onready var grd_list = [em_guard_1, em_guard_2]
@onready var ptrl_list1 = [em_patrol_1, em_patrol_2, em_patrol_3]


var NPC_List = []

func get_active_NPC():
	print("area logic active")
	NPC_List.clear()
#	NPC_List = squads.get_children()
	for node in get_tree().get_nodes_in_group("NPC_unit"):
		if is_ancestor_of(node):
			NPC_List.append(node)
		
#	print("NPC List", NPC_List)
	set_guard_job_1()
	set_guard_job_2()
	set_patrol_job_1()


#==============================

func set_guard_job_1():
	if NPC_List.size() >= 1:
		var NPC_1 = NPC_List.get(0)
		NPC_1.set_guard_on(grd_list[0]) # SENDS GUARD POINT [index] AS ARGUMENT WHEN NPC SCRIPT EXECUTES FUNC set_guard_on
	else: return
		
func set_patrol_job_1():
	if NPC_List.size() >= 2:
		var NPC_0 = NPC_List.get(1)
		NPC_0.set_patrol_on(ptrl_list1) #NPC SCRIPT EXEC set_patrol_on FUNC WITH ptrl_list1 as argument
	else: return

func set_guard_job_2():
	if NPC_List.size() >= 3:
		var NPC_2 = NPC_List.get(2)
		NPC_2.set_guard_on(grd_list[1]) # SENDS GUARD POINT [index] AS ARGUMENT WHEN NPC SCRIPT EXECUTES FUNC set_guard_on
	else: return
