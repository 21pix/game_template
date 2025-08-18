extends Area3D

class_name ammo_PISTOL

@onready var ammo_p: ammo_PISTOL = $"."

var item_selected: bool = false

func _ready() -> void:
	pass
#
func _on_area_entered(area: Area3D) -> void:
	item_selected = true

func _on_area_exited(area: Area3D) -> void:
	item_selected = false
		
func interact(Node):
	if is_instance_valid(ammo_p):
		if item_selected:
			Globals.add_ammo_P.emit()
			Audio.play("sounds/Pickups/collect.ogg")
			ammo_p.queue_free()	
	else:
		return
