extends Sprite2D

@onready var block = get_node("StaticBody2D/CollisionShape2D")


func _physics_process(_delta):
	
	if GlobalData.boss_defeated["Spore"] == true:
		
		queue_free()

func _on_boss_trigger_body_entered(body):
	
	if body.is_in_group("Player"):
		
		get_parent().get_node("Door_block").position = Vector2(0,160)
