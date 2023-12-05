extends Button

signal in_map

@onready var get_map = preload("res://scenes/map_hud.tscn")


func _on_pressed():
	
	var load_map = get_map.instantiate()
	emit_signal("in_map")
	add_child(load_map)
