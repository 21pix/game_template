extends Resource
class_name Character_Equip

@export_subgroup("Character Equip")

@export_dir var skin_folder
@export var Name : String
@export var Faction : String
@export var type : String
@export var Weapon1 : Resource
@export var Weapon2 : Resource
@export var Weapon3 : Resource
@export var reacts_to : String
@export var supplies: Resource

@export var char_dialogs_special: Array[Resource]

#DIALOGS DEFAULT
var dlg_meet = preload("res://gamedata/gameplay/dialogues/meet_default.dtl")
var dlg_warn = preload("res://gamedata/gameplay/dialogues/warning_default.dtl")
var dlg_chat1 = preload("res://gamedata/gameplay/dialogues/random_chat_1.dtl")
var dlg_chat2 = preload("res://gamedata/gameplay/dialogues/random_chat_2.dtl")
var dlg_chat3 = preload("res://gamedata/gameplay/dialogues/random_chat_3.dtl")

#ENEMY REF
@export var enemy_suffix: String
