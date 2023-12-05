extends Area2D


@export var item_name = ""
@export var skin = Texture2D
@export var get_amount = 0
@export var item_id = 0

#@export var pickup_type = "Upgrade"
@export var upgrade_type = false
#@export_enum("Upgrade" , "Standard") var pickup_type


func _ready():
	
	if PlayerInventory.item_tracker["Missiles_pickup"].has(item_id):

		queue_free()
	
	$Item_sprite.texture = skin
	
	
func max_capacity_increase(upgrade):
	
	if upgrade == "Missile":
		
		PlayerInventory.max_missiles += 5
	
	
func limit_to_max_capacity(get_item_type,get_item_name):
	
	#get_item_type is the id for standard pickup
	if get_item_type == -1:
		
		for x in range(get_amount):
			
			if PlayerInventory.inventory[get_item_name].size() < PlayerInventory.max_missiles:
				PlayerInventory.inventory[get_item_name].append(get_item_name)
				
	if get_item_type == -2:
		
		if PlayerInventory.inventory[get_item_name] <= PlayerInventory.max_health:
				PlayerInventory.inventory[get_item_name] += get_amount
				
		if PlayerInventory.inventory[get_item_name] >= PlayerInventory.max_health:
			
			PlayerInventory.inventory[get_item_name] = PlayerInventory.max_health
	

func _on_body_entered(body):
	
	if body.is_in_group("Player"):
		
		for x in range(get_amount):
			
			if upgrade_type:
				
				PlayerInventory.inventory[item_name].append(item_name)
				
		if upgrade_type:
			
			PlayerInventory.item_tracker[item_name + "s_pickup"].append(item_id)
			max_capacity_increase(item_name)
			
		limit_to_max_capacity(item_id,item_name)
			
		queue_free()
