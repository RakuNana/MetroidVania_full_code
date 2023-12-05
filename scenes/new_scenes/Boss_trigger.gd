extends Area2D

@export var boss_name = ""

func _ready():
	
	if GlobalData.boss_defeated[boss_name]:
		
		queue_free()

func _on_body_entered(body):
	
	
	if body.is_in_group("Player"):
		
		GlobalData.boss_awakened[boss_name] = true
		
		get_parent().get_node("AP").play() # audio_player
		queue_free()
