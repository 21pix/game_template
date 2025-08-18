extends RigidBody3D

class_name pickup_weapon_GRZA

@export var weapon_name : String
@export var wpn_PU_current_ammo : int
@export var reserve_ammo : int

func _on_area_entered(area: Area3D) -> void:
	Audio.play("sounds/Pickups/collect.ogg")
	queue_free()


func _on_body_entered(body: Node3D) -> void:
	pass # Replace with function body.
