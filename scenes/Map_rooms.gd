extends TileMap


#@onready var player_map_pos = get_parent().get_parent().get_parent().get_node("Player_loc") 
@onready var player_map_pos = get_parent().get_node("Player_loc") 
@onready var get_map_tiles = get_used_cells(0)


func _ready():
	
	print(get_map_tiles)
	
	var tile_calc = map_to_local(get_map_tiles[PlayerInventory.current_room])
	
	player_map_pos.position = tile_calc
	
	
func _input(event):
	
	if event.is_action_pressed("m_key"):
		
		get_tree().paused = false
		get_parent().queue_free()
