extends Area2D

var start_timer = false

var pin_movement = Vector2()
var life_span  = 0
var speed = 1
var pin_dir_x = 0
var pin_dir_y = 0
var knock_back_strength = 700.0

var damage_amount = 5

func _physics_process(_delta):
	
	check_timer()
	get_direction(pin_dir_x,pin_dir_y)
	#check_rotaion()
	
func get_direction(dir_x,dir_y):
	
	pin_dir_x = dir_x
	pin_dir_y = dir_y
	
	pin_movement.x = speed * pin_dir_x 
	pin_movement.y = speed * pin_dir_y
	
	translate(pin_movement.normalized() * speed)
	
	
func check_rotaion():
	
	self.rotation = get_parent().rotation
	

func check_timer():
	
	life_span += 1
		
	if life_span >= 200:
		
		queue_free()
			

func _on_body_entered(body):
	
	var get_enemy_power = damage_amount
	
	if body.is_in_group("Player"):
		
		var get_dir = global_position.direction_to(body.global_position)
		var apply_knockback = get_dir * knock_back_strength
		
		if apply_knockback.y >= 0 :
		
			apply_knockback.y = apply_knockback.y * -1
		
		body.get_damage(get_enemy_power)
		body.knock_back = apply_knockback
		queue_free()
		
	queue_free()
