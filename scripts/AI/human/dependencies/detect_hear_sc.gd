extends Node
class_name NPCutilDetectHear

@onready var shoot_tmr: RandomTimer = $"../../TIMERS/Shoot_tmr"
@onready var detection_tmr: Timer = $"../../TIMERS/Detection_tmr"
@onready var NPC: NPChuman = $"../.."
@onready var player_friend: String = "PlayerFriend" + str(NPC.char_desc.enemy_suffix)
@onready var player_neutral: String = "PlayerNeutral" + str(NPC.char_desc.enemy_suffix)
@onready var player_enemy: String = "PlayerEnemy" + str(NPC.char_desc.enemy_suffix)

func _ready() -> void:
	Globals.connect("shotfired", player_shooting) #shoot signal from player weapon manager
	Globals.connect("stealth_on", player_stealth_on) #walk speed from player file
	Globals.connect("stealth_off", player_stealth_off) #walk speed from player file
# 	detection_tmr.start(0.5)

func _on_detection_tmr_timeout() -> void:
	pass
				
func player_shooting():
	if !NPC.player_noisy_far:
		NPC.enemy = NPC.player
		var enemy_pos = NPC.enemy.position 
		var npc_pos = NPC.position
		NPC.dist_to_target = enemy_pos.distance_to(npc_pos)
		if NPC.dist_to_target < 100.0:
			shoot_tmr.start(10.0)
			NPC.enemy_detected = true
		elif NPC.dist_to_target > 100.0:
			NPC.enemy_detected = false
			NPC.enemy = null
	else: return
	
func player_stealth_on():
	NPC.enemy_detected = false

func player_stealth_off():
	if !NPC.player.is_in_group(player_friend) and !NPC.player.is_in_group(player_neutral):
		if !NPC.enemy_detected:
			NPC.enemy = NPC.player
			var enemy_pos = NPC.enemy.position 
			var npc_pos = NPC.position
			NPC.dist_to_target = enemy_pos.distance_to(npc_pos)
			if NPC.dist_to_target < 30.0:
				NPC.enemy_detected = true
			else:
				NPC.enemy_detected = false
		else: return
	else: return

func _on_shoot_tmr_timeout() -> void:
	NPC.enemy_detected = false	



		

	
