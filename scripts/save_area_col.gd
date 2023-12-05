extends Area2D


func _on_body_entered(body):
	
	if body.is_in_group("Player"):
		
		body.can_save = true
		body.modulate = Color8(100,100,100)
		print("can_save")


func _on_body_exited(body):
	
	if body.is_in_group("Player"):
		
		body.modulate = Color8(255,255,255)
		body.can_save = false
		print("can_load")
