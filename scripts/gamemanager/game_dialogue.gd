extends Node
class_name GameDialogueManager

var dial_intro_done: bool = false
var dial_complete:bool = false
var dial_task_given: bool = false

@onready var first_meet = false

func _ready() -> void:
	GlobalsNpc.warning_start.connect(start_warning_generic)
	GlobalsNpc.warning_stop.connect(stop_warning)
	Dialogic.signal_event.connect(_on_dialogic_end_signal)
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_released("interact"):
		if GlobalsNpc.dialogue_enabled:
			start_dialogue()
			
#------------------ DIALOGUE INIT
func start_dialogue():
	var NPC_talking = get_tree().get_first_node_in_group("NPC_talking")
	if NPC_talking.char_desc.type == "generic":
		start_dialogue_generic()
	if NPC_talking.char_desc.type == "unique":
		start_dialogue_unique()		
		
#------------------- END SPECIAL DIALOGUE
func _on_dialogic_end_signal(argument:String):
	if argument == "special_dial_end":
		print("special dialogue ended")
		var NPC_talking = get_tree().get_first_node_in_group("NPC_talking")
		NPC_talking.char_desc.type = "generic"
				
#-------------------  MEET NEUTRAL WARNING
func start_warning_generic():
	var NPC_warning = get_tree().get_first_node_in_group("NPC_warning")
	Dialogic.Inputs.auto_advance.enabled_forced = true
	Dialogic.start(NPC_warning.char_desc.dlg_warn)

func stop_warning():
	Dialogic.end_timeline()

#-------------------  GENERIC NPC DIALOGUE --------------------------------------
func start_dialogue_generic():	
	Dialogic.Inputs.auto_advance.enabled_forced = false
	var NPC_talking = get_tree().get_first_node_in_group("NPC_talking")
	if !GlobalsNpc.intro_done:
		Dialogic.start(NPC_talking.char_desc.dlg_meet)
								
	if GlobalsNpc.intro_done:
		var rdm_chat = [NPC_talking.char_desc.dlg_chat1, NPC_talking.char_desc.dlg_chat2, NPC_talking.char_desc.dlg_chat3].pick_random()
		Dialogic.start(rdm_chat)
	else: return
#------------------  UNIQUE NPC DIALOGUE ---------------------------------------

func start_dialogue_unique():
	Dialogic.Inputs.auto_advance.enabled_forced = false
	var NPC_talking = get_tree().get_first_node_in_group("NPC_talking")
	
	Dialogic.start(NPC_talking.char_desc.char_dialogs_special[0])
	
