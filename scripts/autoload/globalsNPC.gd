extends Node
class_name AutoloadNPC

# NPC DATABASE

#------------------------   PLAYER SCENE
var player_squad = preload("res://assets/scenes/player/player_2025.tscn")

#------------------------   RESOURCES VISUALS
var faction1_visual = preload("res://assets/scenes/characters/hmn_npc_faction1.tscn")
var faction2_visual = preload("res://assets/scenes/characters/hmn_npc_faction2.tscn")

#------------------------   RESOURCES EQUIP
var equip_f1 = preload("res://assets/resources/characters_equip/CharEquip_faction1.tres")
var equip_f2 = preload("res://assets/resources/characters_equip/CharEquip_faction2.tres")
var equip_joe = preload("res://assets/resources/characters_equip/CharEquip_joe.tres")
var equip_mouse = preload("res://assets/resources/characters_equip/CharEquip_mouse.tres")
#------------------------   SQUADS DESCR 
#---- DEFAULT
var squad_f1_default = {"squad_visual": faction1_visual, "squad_equip": equip_f1}
var squad_f2_default = {"squad_visual": faction2_visual, "squad_equip": equip_f2}

#---- UNIQUE
var squad_joe = {"squad_visual": faction1_visual, "squad_equip": equip_joe}
var squad_mouse = {"squad_visual": faction1_visual, "squad_equip": equip_mouse}
#--------------------------------------------------------------------------
# DIALOGUE
signal warning_start
signal warning_stop

var dial_no_move: bool = false
var dialogue_enabled: bool = false
var warning_enabled: bool = false
var intro_done: bool = false

# TASKS
var new_task: String
var task_started: bool
var task_success: bool
var task_failed: bool
