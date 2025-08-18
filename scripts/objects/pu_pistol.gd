extends Area3D

@onready var pistol: Area3D = $"."

var item_selected: bool = false

func _ready() -> void:
	pass
#
func _on_area_entered(area: Area3D) -> void: # Player collides with item coll box
	item_selected = true

func _on_area_exited(area: Area3D) -> void:
	item_selected = false
		
func interact(Node):
	if is_instance_valid(pistol):
		if item_selected:
			Globals.add_pistol.emit() # Signal for weapon manager
			Audio.play("sounds/Pickups/collect.ogg")
			pistol.queue_free()	
	else:
		return
