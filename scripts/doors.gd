extends Area2D

var opened = false

@export var is_red_door = false


func _ready():
	
	if is_red_door:
	
		$Sprite2D.set_frame(2)


func _on_area_entered(area):
	
	if area.is_in_group("P_bullets") and !opened and !is_red_door:
		
		opened = true
		$Sprite2D.set_frame(1)
		$Door_block.queue_free()
		
	if area.is_in_group("Missiles_group") and !opened and is_red_door:
		$Sprite2D.set_frame(3)
		opened = true
		$Door_block.queue_free()



