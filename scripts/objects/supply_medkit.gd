extends Area3D
class_name ItemMedkit
@export var sound: String

@onready var object_medkit: Area3D = $"."

var item_selected: bool = false


func _on_area_entered(area: Area3D) -> void:
	item_selected = true

func _on_area_exited(area: Area3D) -> void:
	item_selected = false
		
func interact(Node):
	if is_instance_valid(object_medkit):
		if item_selected:
			GlobalsPlayer.add_object.emit("medkit", 1)
			Audio.play(sound)
			object_medkit.queue_free()
	else:
		return
