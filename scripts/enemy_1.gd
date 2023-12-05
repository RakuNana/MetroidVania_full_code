extends Area2D


@export var damage_amount : int


func _physics_process(_delta):
	
	var check_bodies = get_overlapping_bodies()
	
	for x in check_bodies:
		
		if x.is_in_group("Player"):
			
			x.get_damage(damage_amount)
