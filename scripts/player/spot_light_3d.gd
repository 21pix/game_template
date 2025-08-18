extends SpotLight3D

@onready var spot_light_3d: SpotLight3D = $"."
var light_on: bool


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

		
	if Input.is_action_just_pressed("light"):
		if light_on:
			spot_light_3d.visible = false
			light_on = false
		else:
			spot_light_3d.visible = true
			light_on = true	
