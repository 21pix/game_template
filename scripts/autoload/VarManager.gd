extends Node

signal updateAmmo_P
signal updateAmmo_R
signal updateAmmo_S
signal updateAmmo_M
signal updateAmmo_X

# ----------------------- INVENTORY ITEMS








# ----------------------------------------------

func _on_weapon_container_current_ammo_m(ammo_M: Variant) -> void:
	emit_signal("updateAmmo_M", ammo_M)
#	print("AmmoM", ammo_M)

func _on_weapon_container_current_ammo_p(ammo_current, ammo_P) -> void:
#	print("Pistol", ammo_current, "--", ammo_P)
	emit_signal("updateAmmo_P", ammo_current, ammo_P)
	
func _on_weapon_container_current_ammo_r(ammo_current, ammo_R) -> void:
#	print("Rifle", ammo_current, "--", ammo_R)
	emit_signal("updateAmmo_R", ammo_current, ammo_R)
	
func _on_weapon_container_current_ammo_s(ammo_current, ammo_S) -> void:
#	print("Shotgun", ammo_current, "--", ammo_S)
	emit_signal("updateAmmo_S", ammo_current, ammo_S)
	
func _on_weapon_container_current_ammo_x(ammo_X: Variant) -> void:
	emit_signal("updateAmmo_X", ammo_X)
#	print("AmmoX", ammo_X)

#----------------------------------------------------------------------------------


func _on_weapon_container_pickup_ammo_m(ammo_M: Variant) -> void:
	emit_signal("updateAmmo_M", ammo_M)
#	print("AmmoM", ammo_M)

func _on_weapon_container_pickup_ammo_p(ammo_P: Variant) -> void:
	emit_signal("updateAmmo_P", ammo_P)
#	print("AmmoP", ammo_P)

func _on_weapon_container_pickup_ammo_r(ammo_R: Variant) -> void:
	emit_signal("updateAmmo_R", ammo_R)
#	print("AmmoR", ammo_R)

func _on_weapon_container_pickup_ammo_s(ammo_current, ammo_S) -> void:
	emit_signal("updateAmmo_S", ammo_current, ammo_S)
#	print("AmmoS", ammo_S)

func _on_weapon_container_pickup_ammo_x(ammo_X: Variant) -> void:
	emit_signal("updateAmmo_X", ammo_X)
#	print("AmmoX", ammo_X)

func _on_weapon_container_pickup_weapon() -> void:
	pass
#	print("Weapon Pickup")
