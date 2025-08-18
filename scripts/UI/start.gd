extends Node2D

@onready var option_button: OptionButton = $CanvasLayer/OptionButton
@onready var levels: Node3D = $"../../levels"
@onready var level_instance: Node3D
@onready var start: Node2D = $"."
@onready var level_test = preload("res://assets/scenes/levels/elevation/elevation_map.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func unload_level():
	if (is_instance_valid(level_instance)):
		level_instance.queue_free()
		
func load_level(level_name : String):
	unload_level()
	var level_path := "res://scenes/%s.tscn" % level_name
	var level_resource := load(level_path)
	if level_resource:
		level_instance = level_resource.instantiate()
		levels.add_child(level_instance)
		
func _on_button_pressed() -> void:
#	get_tree().change_scene_to_file("res://scenes/elevation_map.tscn")
	load_level("elevation_map")
	self.queue_free()

func _on_button_2_pressed() -> void:
	get_tree().quit()

func center_window():
	var Center_Screen = DisplayServer.screen_get_position()+DisplayServer.screen_get_size()/2
	var Window_Size = get_window().get_size_with_decorations()
	get_window().set_position(Center_Screen-Window_Size/2)

func _on_option_button_item_selected(index: int) -> void:
	match index:
		0:
			get_window().set_size(Vector2(1280,720))
			center_window()
		1:
			get_window().set_size(Vector2(1600,900))
			center_window()
		2:
			get_window().set_size(Vector2(1920,1080))
			center_window()
		3:
			get_window().set_size(Vector2(2560,1440))
			center_window()
