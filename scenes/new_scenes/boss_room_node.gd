extends Node

@export var boss_name = ""

func _ready():
	
	if GlobalData.boss_defeated[boss_name]:
		
		get_node("Door_block").queue_free()
		get_node("Boss_trigger").queue_free()
		get_node("Boss").queue_free()
