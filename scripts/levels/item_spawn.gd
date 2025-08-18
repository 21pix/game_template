extends Node


@onready var item_spawn: Node = $"." # Parent Node
var ammo_r_item = preload("res://objects/pickups/PU_Ammo_R.tscn") # Item scene
@onready var i_spawn_1: Marker3D = $ISpawn1 # Spawn loc

func _ready() -> void:
	spawn_ISpawn1()





func spawn_ISpawn1():
	
	
	for i in range(1):

		var ammoSpawn1 = ammo_r_item.instantiate()
		item_spawn.add_child(ammoSpawn1)
		ammoSpawn1.position = i_spawn_1.global_position
