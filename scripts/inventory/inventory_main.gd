extends CanvasLayer
class_name Inventorymain

@onready var inventory_player: Inventory = $inventory
@onready var inventory_b: InventoryB = $inventoryb

func open_player_inventory():
	inventory_player.visible = true
	GlobalsPlayer.inventory_on = true

	
func close_player_inventory():		
	inventory_player.visible = false
	GlobalsPlayer.inventory_on = false

		
func open_both_inventory():
	inventory_b.initialize_inventory()
	inventory_player.visible = true
	inventory_b.visible = true
	GlobalsPlayer.inventory_on = true
	GlobalsPlayer.inventory_b_on = true

		
func close_both_inventory():	
	inventory_player.visible = false
	inventory_b.visible = false
	GlobalsPlayer.inventory_on = false
	GlobalsPlayer.inventory_b_on = false
	print("inventory B list : ", inventory_b.inventoryb_list)
	print("inventory globals list : ",GlobalsPlayer.inventory_b_content)
