extends Node
class_name PlayerEquipment

@onready var player_weaponcont: Node
@onready var player_weaponset: Array
@onready var player_itemset: Array
	
func init_player_equipment():
#	await get_tree().create_timer(1.5).timeout
	player_weaponcont = get_tree().get_first_node_in_group("weaponcontainer")
	player_weaponset = player_weaponcont.WeaponSet
	player_itemset = GlobalsPlayer.player_equip_items.supplies
	
	GlobalsPlayer.player_equip_full.player_stuff.append_array(player_weaponset)
	GlobalsPlayer.player_equip_full.player_stuff.append_array(player_itemset)

func update_player_equipment_add(item, amount):
	for n in amount:
		GlobalsPlayer.player_equip_full.player_stuff.append(item)

func update_player_equipment_remove(item):
	GlobalsPlayer.player_equip_full.player_stuff.erase(item)
