extends Node2D

var toggled: bool = false

@onready var task_inventory: CanvasLayer = $task_inventory

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("show_tasks"):
		if !toggled:
			task_inventory.visible = true
			toggled = true

		else:
			task_inventory.visible = false
			toggled = false

	
