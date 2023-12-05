extends TextureRect




func _ready():
	
	$current_ammo.text = str(PlayerInventory.inventory["Missile"].size())
	$Max_ammo.text = str(PlayerInventory.max_missiles)
