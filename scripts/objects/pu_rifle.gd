extends Area3D

@onready var rifle: Area3D = $"."

var item_selected: bool = false

func _ready() -> void:
	pass
#
func _on_area_entered(area: Area3D) -> void:
	item_selected = true

func _on_area_exited(area: Area3D) -> void:
	item_selected = false
		
func interact(Node):
	if is_instance_valid(rifle):
		if item_selected:
			Globals.add_rifle.emit()
			Audio.play("sounds/Pickups/collect.ogg")
			rifle.queue_free()	
	else:
		return
