extends Area2D


@export_file("*.tscn") var portal_exit
@export var portal_spawn : Vector2

@export var send_next_room_id = 0


func _on_body_entered(body):
	
	if portal_exit and body.is_in_group("Player"):
		
		PlayerInventory.current_room = send_next_room_id
		get_tree().change_scene_to_file(portal_exit)
		PlayerInventory.players_current_pos = portal_spawn
