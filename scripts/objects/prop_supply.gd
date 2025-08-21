extends Area3D
class_name PropSupply
@export var sound: String
@export var prop_name: String

@onready var prop_self: Area3D = $"."

var item_selected: bool = false


func _on_area_entered(area: Area3D) -> void:
	item_selected = true

func _on_area_exited(area: Area3D) -> void:
	item_selected = false
		
func interact(Node):
	if is_instance_valid(prop_self):
		if item_selected:
			GlobalsPlayer.add_object.emit(prop_name, 1)
			Audio.play(sound)
			prop_self.queue_free()
	else:
		return
