extends Node3D

@onready var logic: Node = $"../Logic"



func _on_area_3d_body_entered(body: Node3D) -> void:
	await get_tree().create_timer(1.0).timeout
	logic.get_active_NPC()
