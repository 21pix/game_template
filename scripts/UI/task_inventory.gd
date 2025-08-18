extends Node

@onready var tasks_row: VBoxContainer = $Control/tasks_row

func add_new_task(desc):
	var desc_label = Label.new()
	desc_label.text = desc	
	tasks_row.add_child(desc_label)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
