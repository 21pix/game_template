extends Node
class_name GameTaskManager
@onready var tasks_list: GameTasksList = $tasks_list
@onready var task_inventory: CanvasLayer = $"../../UI/task_inventory"


func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _on_dialogic_signal(argument:String):
	if argument == "task_started_ui":
		task_started_ui(GlobalsNpc.new_task)

#----------------- UI

func task_started_ui(new_task):
#	print("new task : ",new_task)
	for active_task in tasks_list.game_tasks:
		if active_task["ID"] == str(new_task):
			var active_task_descr = active_task["descr"]
			task_inventory.add_new_task(active_task_descr)
			print(active_task_descr)
