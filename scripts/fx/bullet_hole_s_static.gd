extends Sprite3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var decal_timer = $Timer
	decal_timer.start()
	queue_free()
