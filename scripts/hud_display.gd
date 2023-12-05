extends CanvasLayer


func _ready():
	
	$Missle_name.text = "Missiles :"
	$Health_text.text = "Health :"
	
func _physics_process(_delta):
	
	$Control/amount.text = str(PlayerInventory.inventory["Missile"].size())

	$current_health.text = str(PlayerInventory.inventory["Health"])
