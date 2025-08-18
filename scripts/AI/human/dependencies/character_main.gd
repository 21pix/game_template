extends Node
class_name NPCcharactermain

#nodes
@onready var NPC: NPChuman = $"../.."
@onready var char_wpn_equiped: NPCweaponDesc = $"../CharacterWeapon"

#items reference
@onready var npc_name = NPC.char_desc.Name
@onready var npc_faction = NPC.char_desc.Faction
@onready var npc_weapon = char_wpn_equiped.char_wpn
@onready var npc_supplies = NPC.char_desc.supplies.npc_supplies
@onready var npc_supplies_drop: Array = []

func _ready() -> void:
	npc_supplies_drop = npc_supplies
		
func drop_items():
	print("drop: ", npc_supplies_drop[0].item_name, " / ", npc_supplies_drop[1].item_name, " / ", char_wpn_equiped.char_wpn.wpn_name)
