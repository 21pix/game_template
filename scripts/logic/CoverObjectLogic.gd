extends Node

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var cover_point_ray: RayCast3D = $CoverPointRay
@onready var cover_timer: Timer = $CoverTimer
@onready var cover_point_target: Node3D = $CoverPointRay/CoverPointTarget




func _on_body_entered(body: Node3D) -> void:

	cover_timer.start()

	
func _on_cover_timer_timeout() -> void:


	cover_point_ray.look_at(player.position)
	cover_point_ray.force_raycast_update()
