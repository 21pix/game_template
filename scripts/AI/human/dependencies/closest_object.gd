extends Node
class_name ClosestObject

@onready var NPC: NPChuman = $"../.."

func get_closest_object(ObjectList):

	var minDistance
#	var minDistanceObject
	for obj in ObjectList:
		var distance = NPC.position.distance_to(obj.position)
#		print(distance)

		# This is for our first iteration
		if not NPC.minDistanceObject:
			minDistance = distance
			NPC.minDistanceObject = obj
			continue
		
		if distance < minDistance:
			minDistance = distance
			NPC.minDistanceObject = obj
