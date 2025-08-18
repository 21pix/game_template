extends Resource

@export var task_name: String
@export var	ID: String
@export var	title: String
@export var	descr: String
@export var	object_needed: String
@export var	amount: int

func executed():
	var executed = str(ID)+"_executed"
	GlobalsGameManager.executed = true
