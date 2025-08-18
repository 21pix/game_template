extends Node
class_name LevelSpawner

# Spawn points reference
@onready var building_spawn_1: Marker3D = $"../Area1/Camps/Building_spawn1"
@onready var a1_spawn_1: Marker3D = $"../Area1/Camps/A1_spawn1"
@onready var a1_spawn_2: Marker3D = $"../Area1/Camps/A1_spawn2"
@onready var a1_spawn_3: Marker3D = $"../Area1/Camps/A1_spawn3"
@onready var a1_spawn_4: Marker3D = $"../Area1/Camps/A1_spawn4"
@onready var a1_spawn_5: Marker3D = $"../Area1/Camps/A1_spawn5"
@onready var a1_player_spawn: Marker3D = $"../Area1/Camps/A1_player_spawn"
@onready var a2_spawn_1: Marker3D = $"../Area1/Camps/A2_spawn1"
@onready var level_spawn_list: Array = [building_spawn_1, a1_spawn_1, a1_spawn_2, a1_spawn_3, a2_spawn_1]

#------
var lvlallspawn: Array
var a2_s1spawn: Array
var a1_s1_faction1_group1: Dictionary # SQUAD SPAWN DESCRIPTION
var a1_s2_faction1_group1: Dictionary # SQUAD SPAWN DESCRIPTION
var a2_s1_faction2_group1: Dictionary # SQUAD SPAWN DESCRIPTION
var a1_s4_faction2_group1: Dictionary
var a1_s5_faction2_group1: Dictionary
var build_s1_faction1_group1: Dictionary
var a1_s1_Joe: Dictionary
var a1_s3_Mouse: Dictionary
#-------------------------------------------------------------------------------

func _ready() -> void:

#---------------  NPC SQUADS SPAWN	

	a1_s1_faction1_group1 = {
		"min_units": 2,
		"max_units": 2,
		"max_dist": 6,
		"squad_desc": GlobalsNpc.squad_f1_default,
		"spawn_loc": a1_spawn_1,
		"squad_ID": "a1_s1_faction1_group1"	
	}

	a1_s2_faction1_group1 = {
		"min_units": 1,
		"max_units": 1,
		"max_dist": 6,
		"squad_desc": GlobalsNpc.squad_f1_default,
		"spawn_loc": a1_spawn_2,
		"squad_ID": "a1_s2_faction1_group1"	
	}
	
	a1_s1_Joe = {
		"min_units": 1,
		"max_units": 1,
		"max_dist": 6,
		"squad_desc": GlobalsNpc.squad_joe,
		"spawn_loc": a1_spawn_1,
		"squad_ID": "a1_s1_Joe"	
	}

	a1_s3_Mouse = {
		"min_units": 1,
		"max_units": 1,
		"max_dist": 6,
		"squad_desc": GlobalsNpc.squad_mouse,
		"spawn_loc": a1_spawn_3,
		"squad_ID": "a1_s3_Mouse"	
	}
	
	a2_s1_faction2_group1 = {
		"min_units": 2,
		"max_units": 2,
		"max_dist": 6,
		"squad_desc": GlobalsNpc.squad_f2_default,
		"spawn_loc": a2_spawn_1,
		"squad_ID": "a2_s1_faction2_group1"	
	}	

	a1_s4_faction2_group1 = {
		"min_units": 2,
		"max_units": 2,
		"max_dist": 6,
		"squad_desc": GlobalsNpc.squad_f2_default,
		"spawn_loc": a1_spawn_4,
		"squad_ID": "a1_s4_faction2_group1"	
	}
	
	a1_s5_faction2_group1 = {
		"min_units": 2,
		"max_units": 2,
		"max_dist": 6,
		"squad_desc": GlobalsNpc.squad_f2_default,
		"spawn_loc": a1_spawn_5,
		"squad_ID": "a1_s5_faction2_group1"	
	}
		
	build_s1_faction1_group1 = {
		"min_units": 2,
		"max_units": 2,
		"max_dist": 3,
		"squad_desc": GlobalsNpc.squad_f1_default,
		"spawn_loc": building_spawn_1,
		"squad_ID": "build_s1_faction1_group1"	
	}										
#-------------- ALL SPAWNS COMBINED FOR EXPORT
#	lvlallspawn = [a1_s3_Mouse, a1_s1_Joe, a1_s2_faction1_group1]
	lvlallspawn = [a1_s3_Mouse,a1_s1_Joe,a1_s1_faction1_group1,a1_s2_faction1_group1,a1_s4_faction2_group1,a1_s5_faction2_group1]
#	lvlallspawn = [a1_s4_faction2_group1,a1_s1_faction1_group1]
	a2_s1spawn = [a2_s1_faction2_group1]
