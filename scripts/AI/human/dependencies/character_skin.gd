extends Node
class_name NPCcharacterskin

@onready var NPC_mesh: MeshInstance3D = $"../../Armature/Skeleton3D/stalker_neutral_3Shape"
@onready var NPC: NPChuman = $"../.."
@onready var skin_list = []
@onready var char_mat = NPC_mesh.get_active_material(0)

func _ready() -> void:
	get_skins_list()
#	print(char_mat)
	
func get_skins_list():
	var path = NPC.char_desc.skin_folder
	var dir = DirAccess.open(path)

	dir.list_dir_begin()
	while true:
		var file_name = dir.get_next()
		if file_name == "": #break the while loop when get_next() returns ""
			break
		elif !file_name.begins_with(".") and !file_name.ends_with(".import"): #if !file_name.ends_with(".import"):
			skin_list.append(load(path + "/" + file_name))
	dir.list_dir_end()
#	print("skin list: ", skin_list)
	set_new_skin()
	
func set_new_skin():
	var new_char_mat = char_mat.duplicate()
	NPC_mesh.set_surface_override_material(0, new_char_mat)
	char_mat.albedo_texture = skin_list.pick_random()

	
