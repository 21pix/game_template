extends CanvasLayer

@onready var e_interact: VBoxContainer = $"E interact"
@onready var crosshair: TextureRect = $Crosshair

@onready var CurrentWeaponLabel = $VBoxContainer2/HBoxContainer/CurrentWeapon
@onready var CurrentammoLabel = $VBoxContainer/HBoxContainer2/CurrentAmmo
@onready var health_bar: ProgressBar = $HealthBar
@onready var player_hit_rect: TextureRect = $PlayerHitRect

func _ready() -> void:
	pass


func _on_weapon_container_weapon_changed(Weapon_Name) -> void:
	CurrentWeaponLabel.set_text(Weapon_Name)


func _on_manager_update_ammo_r(ammo_current, ammo_R) -> void:
	CurrentammoLabel.set_text(str(ammo_current)+ " / "+ str(ammo_R))


func _on_manager_update_ammo_p(ammo_current, ammo_P) -> void:
	CurrentammoLabel.set_text(str(ammo_current)+ " / "+ str(ammo_P))


func _on_manager_update_ammo_s(ammo_current, ammo_S) -> void:
	CurrentammoLabel.set_text(str(ammo_current)+ " / "+ str(ammo_S))


func _on_player_health_updated(health) -> void:
	health_bar.value = health


func _on_player_player_hit() -> void:
#	player_hit_rect.visible = true
#	await get_tree().create_timer(0.2).timeout
#	player_hit_rect.visible = false
	pass

func _on_interact_detect_area_entered(area: Area3D) -> void:
	e_interact.visible = true
	crosshair.visible = false

func _on_interact_detect_area_exited(area: Area3D) -> void:
	e_interact.visible = false
	crosshair.visible = true
