extends Area3D

class_name ammo_RPG

@export var ammo_type : String
@export var ammo_X : int

func _on_area_entered(area: Area3D) -> void:
	Audio.play("sounds/Pickups/collect.ogg")
	queue_free()
