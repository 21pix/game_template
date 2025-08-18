extends Node

var health = 20
		
func _ready() -> void:
	globals.Hit.connect

func Enemy_Hit(damage):

	health -= damage
	print(health)
	if health <= 0:
		get_tree().queue_free()
		
