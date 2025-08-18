extends CanvasLayer
@onready var trade_info: Label = $Control/VBoxContainer/trade_info


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#----------------------- PLAYER RECEIVE
func _on_trade_manager_trade_received(item, amount) -> void:
	trade_info.visible = true
	trade_info.text = "You received " + str(amount) + " " + str(item)
	await get_tree().create_timer(3.0).timeout
	trade_info.text = ""
	turn_trade_off()

#---------------------- PLAYER LOSE
func _on_trade_manager_trade_lost(item, amount) -> void:
	trade_info.visible = true
	trade_info.text = "You lost " + str(amount) + " " + str(item)
	await get_tree().create_timer(3.0).timeout
	trade_info.text = ""
	turn_trade_off()
#---------------------- TURN OFF LABEL
func turn_trade_off():
	trade_info.visible = false
