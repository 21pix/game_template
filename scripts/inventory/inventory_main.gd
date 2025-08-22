extends CanvasLayer
class_name Inventorymain

@onready var inventory_player: Inventory = $inventory
@onready var inventory_bb: InventoryB = $inventoryb

func open_player_inventory():
	inventory_player.visible = true
	GlobalsPlayer.inventory_on = true
	print("player inventory on : ", GlobalsPlayer.inventory_on," / ", "Alt inventory on : ", GlobalsPlayer.inventory_b_on)
	
func close_player_inventory():		
	inventory_player.visible = false
	GlobalsPlayer.inventory_on = false
	print("player inventory on : ", GlobalsPlayer.inventory_on," / ", "Alt inventory on : ", GlobalsPlayer.inventory_b_on)
		
func open_both_inventory():
	inventory_player.visible = true
	inventory_bb.visible = true
	GlobalsPlayer.inventory_on = true
	GlobalsPlayer.inventory_b_on = true
	print("player inventory on : ", GlobalsPlayer.inventory_on," / ", "Alt inventory on : ", GlobalsPlayer.inventory_b_on)
		
func close_both_inventory():		
	inventory_player.visible = false
	inventory_bb.visible = false
	GlobalsPlayer.inventory_on = false
	GlobalsPlayer.inventory_b_on = false
	print("player inventory on : ", GlobalsPlayer.inventory_on," / ", "Alt inventory on : ", GlobalsPlayer.inventory_b_on)
