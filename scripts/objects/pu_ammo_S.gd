extends Area3D

class_name ammo_SHOTGUN

@onready var ammo_s: ammo_SHOTGUN = $"."

var item_selected: bool = false

func _ready() -> void:
	pass
#
func _on_area_entered(area: Area3D) -> void:
	item_selected = true

func _on_area_exited(area: Area3D) -> void:
	item_selected = false
		
func interact(Node):
	if is_instance_valid(ammo_s):
		if item_selected:
			Globals.add_ammo_S.emit()
			Audio.play("sounds/Pickups/collect.ogg")
			ammo_s.queue_free()	
	else:
		return
