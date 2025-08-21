extends Node
class_name AutoloadGeneral

var BulletHoleS = preload("res://assets/scenes/fx/BulletHoleSStatic.tscn")
var BulletHoleM = preload("res://assets/scenes/fx/BulletHoleMStatic.tscn")
var BulletHoleD = preload("res://assets/scenes/fx/BulletHoleDebug.tscn")
var impact = preload("res://assets/scenes/fx/impact.tscn")
var bloodpart = preload("res://assets/scenes/fx/bloodpart.tscn")

signal level_loaded

signal death
signal reload
signal Hit
signal Update_Ammo
signal Weapon_Changed
signal shotfired

signal area_cover_list
signal area_camp_list
signal ptrl_list
signal ptrl_list1
signal ptrl_list2
signal ptrl_list3
signal ptrl_list4
signal ptrl_list5
signal ptrl_list6


signal stealth_on
signal stealth_off

signal door_open
signal interact
#-------------- INVENTORY

signal add_ammo_P
signal add_ammo_S
signal add_ammo_R
signal add_ammo_M
signal add_ammo_X
signal add_rifle
signal add_shotgun
signal add_pistol
signal add_health
