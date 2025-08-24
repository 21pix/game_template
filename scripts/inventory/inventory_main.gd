extends CanvasLayer
class_name Inventorymain

@onready var inventory_player: Inventory = $inventory_player
@onready var inventory_trader: Inventory = $inventory_trader

func open_player_inventory():
	inventory_player.visible = true
	GlobalsPlayer.inventory_on = true
	
func close_player_inventory():		
	inventory_player.visible = false
	GlobalsPlayer.inventory_on = false

func open_both_inventory():
	inventory_trader.initialize_inventory()
	inventory_player.visible = true
	inventory_trader.visible = true
	GlobalsPlayer.inventory_on = true
	GlobalsPlayer.inventory_b_on = true
		
func close_both_inventory():	
	inventory_player.visible = false
	inventory_trader.visible = false
	GlobalsPlayer.inventory_on = false
	GlobalsPlayer.inventory_b_on = false
