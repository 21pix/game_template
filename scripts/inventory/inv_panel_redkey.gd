extends Node

@onready var label: Label = $Label
@onready var inv_panel: Panel = $"."



func _ready() -> void:
	globals.used_redkey.connect(delete_item)
	
func delete_item():
	inv_panel.queue_free()
