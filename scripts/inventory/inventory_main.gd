extends CanvasLayer
class_name Inventorymain

@onready var inventory_player = $inventory_player
@onready var inventory_trader = $inventory_trader
@onready var player_equipment = get_tree().get_first_node_in_group("player_equipment")

func _ready() -> void:
	player_equipment.init_player_equipment()
	inventory_player.initialize_inventory()
		
func open_player_inventory():
	inventory_player.visible = true
	GlobalsPlayer.inventory_player_on = true
	
func close_player_inventory():		
	inventory_player.visible = false
	GlobalsPlayer.inventory_player_on = false

func open_both_inventory():
	inventory_trader.initialize_inventory()
	inventory_player.visible = true
	inventory_trader.visible = true
	GlobalsPlayer.inventory_player_on = true
	GlobalsPlayer.inventory_trader_on = true
		
func close_both_inventory():	
	inventory_player.visible = false
	inventory_trader.visible = false
	GlobalsPlayer.inventory_player_on = false
	GlobalsPlayer.inventory_trader_on = false
