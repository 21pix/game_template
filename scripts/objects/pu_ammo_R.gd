extends Area3D

class_name ammo_RIFLE

@onready var ammo_r: ammo_RIFLE = $"."

var item_selected: bool = false

func _ready() -> void:
	pass
#
func _on_area_entered(_area: Area3D) -> void:
	item_selected = true

func _on_area_exited(_area: Area3D) -> void:
	item_selected = false
		
func interact(Node):
	if is_instance_valid(ammo_r):
		if item_selected:
			Globals.add_ammo_R.emit()
			Audio.play("sounds/Pickups/collect.ogg")
			ammo_r.queue_free()	
	else:
		return
