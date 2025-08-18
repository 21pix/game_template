extends Node
class_name CoverDetect

@onready var NPC: NPChuman = $"../.."
@onready var cover_area = preload("res://assets/scenes/logic/coverzone.tscn")

func get_nearest_cover() -> void:

	var minDistance
	var minDistanceObject
	for obj in NPC.cover_list:
		var distance = NPC.position.distance_to(obj.position)
#		print(distance)

		if not minDistanceObject:
			minDistance = distance
			minDistanceObject = obj
			continue
		
		if distance < minDistance:
			minDistance = distance
			minDistanceObject = obj
			
	NPC.closest_cover = minDistanceObject
	print("closest cover: ", NPC.closest_cover)
	
	var cov_area = cover_area.instantiate()
	NPC.closest_cover.add_child(cov_area)
	cov_area.global_position = NPC.closest_cover.global_position
	
	NPC.cover_zone_target.clear() # RESET COVER LIST
	NPC.cover_zone_target.append(cov_area) # ADD TO COVER TARGET LIST
	
	NPC.take_cover = true

#---- GET NEAREST COVER ZONE

func get_nearest_cover_zone() -> void:

	var minDistance
	var minDistanceObject
	for obj in NPC.cover_path_nodes_list:
		var distance = NPC.global_position.distance_to(obj.global_position)
#		print(distance)

		if not minDistanceObject:
			minDistance = distance
			minDistanceObject = obj
			continue
		
		if distance < minDistance:
			minDistance = distance
			minDistanceObject = obj
			
	NPC.closest_cover_zone = minDistanceObject
#	print("closest targetz :", closest_cover_zone)
	NPC.cover_path_node_target.clear()
	NPC.cover_path_node_target.append(NPC.closest_cover_zone)
	
#---- GET COVER LIST

func instanciate_cover():
	var cov_area = cover_area.instantiate()
	NPC.closest_cover.add_child(cov_area)
	cov_area.global_position = NPC.closest_cover.global_position
	
	NPC.cover_zone_target.clear() # RESET COVER LIST
	NPC.cover_zone_target.append(cov_area) # ADD TO COVER TARGET LIST
