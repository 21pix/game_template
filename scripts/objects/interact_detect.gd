extends Area3D

@onready var interact_detect: Area3D = $"."
@onready var interact_ray: RayCast3D = $InteractRay
@onready var PU_Ammo_R = get_tree().get_first_node_in_group("ammo_R")


var item_detected: bool = false

func _ready() -> void:
	pass

func _on_area_entered(area: Area3D) -> void:
	Globals.item_detected = true
	
func _on_area_exited(area: Area3D) -> void:
	Globals.item_detected = false
			
func interact():
	interact_ray.force_raycast_update()
	var item_collider = interact_ray.get_collider()
#	print("raycast colliding with:", item_collider)
	if item_collider.has_method("interact"):
		item_collider.interact(self) # Fires Item interact function ( add + sound + delete)
	else: return
