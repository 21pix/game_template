extends Node
class_name GameNPCManager

@onready var update_npc_stats: Timer = $Timer
@onready var spawn_actors: GameSpawnActors = $"../spawn_actors"
@onready var npc_active_list: Array
@onready var squads_active_list: Array


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(2.0).timeout
	update_npc_stats.start(2.0)


func _on_timer_timeout() -> void:
	get_active_squad_list()

func get_active_squad_list():	
	npc_active_list = get_tree().get_nodes_in_group("NPC_unit")
	squads_active_list.clear()
	for node in npc_active_list:
		var character = node.character_self
		var character_squad = character.squad_id
		squads_active_list.append(character_squad)
		
#	print(npc_active_list)
#	print(squads_active_list)
	
		
				
