extends Node

@onready var label: Label = $Label



func _ready() -> void:
	globals.used_purplekey.connect(delete_item)
	
func delete_item():
	get_tree().queue_free()
