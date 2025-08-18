extends Node
class_name GameTasksList

var task_state= {
	"started": "started",
	"failed": "failed",
	"done": "done"
}

# ----------- TASKS
var joe_task1= {
	"ID": "joe_task1",
	"title": "kill them all",
	"descr": "kill all the guys in the other camp"
}

var mouse_task= {
	"ID": "mouse_task",
	"title": "bring back medkits",
	"descr": "find 3 medkits and bring it back to Mouse",
	"object_needed": "medkit",
	"amount": 3,
}

# ----------- GAME TASKS

var game_tasks = [
	joe_task1, mouse_task
]

@export var game_tasks_alt = []
