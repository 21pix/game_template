extends RigidBody3D

var health = 150
		
func _ready() -> void:
	Globals.Hit.connect(_ApplyImpulse)

func _ApplyImpulse(GunDamage, Bullet_Direction):
	
	apply_impulse(Bullet_Direction * GunDamage)
	
func Enemy_Hit(damage):

	health -= damage
	if health <= 0:
		queue_free()
		
