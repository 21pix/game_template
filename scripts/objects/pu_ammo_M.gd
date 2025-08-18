extends Area3D

class_name ammo_PLASMA

@export var ammo_type : String
@export var ammo_M : int


func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("Player"):
		Audio.play("sounds/Pickups/collect.ogg")
		queue_free()
