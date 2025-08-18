extends CanvasLayer

@onready var CurrentWeaponLabel = $VBoxContainer/HBoxContainer/CurrentWeapon
@onready var CurrentammoLabel = $VBoxContainer/HBoxContainer2/CurrentAmmo


func _on_weapon_container_update_ammo(Ammo):
	CurrentammoLabel.set_text(str(Ammo[0])+ "/"+ str(Ammo[1]))


func _on_weapon_container_weapon_changed(Weapon_Name):
	CurrentWeaponLabel.set_text(Weapon_Name)
