extends Area3D
class_name NPCHitbox

@onready var NPC: NPChuman = $"../../../.."
@export var damage: int
@onready var enemy_group : String = NPC.char_desc.enemy_suffix
signal body_part_hit(dam)


func Enemy_Hit(damage):
	emit_signal("body_part_hit", damage)
	if enemy_group == "_to_f1":
		GlobalsPlayer.player_enemy_to_f1.emit()
	if enemy_group == "_to_f2":
		GlobalsPlayer.player_enemy_to_f2.emit()
