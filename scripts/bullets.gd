extends Area2D


var bullet_speed = 10
var bullet_movement = Vector2()
var bullet_direction = 1 
var bullet_life = 0
var morphball = false

var aiming_up = false
var aiming_down = false

@export var power : int 


func _ready():
	
	add_to_group("P_bullets")

func check_direction(dir):
	
	bullet_direction = dir
	
	if dir == 1:
		
		$ammo.flip_h = true
		
	if dir == -1:
		
		$ammo.flip_h = false
	
	
func is_currently_aiming_up(is_true):
	
	aiming_up = is_true
	
	
func is_currently_aiming_down(is_true):
	
	aiming_down = is_true

func _physics_process(delta):
	
	bullet_life += 1
	
	bullet_movement.x = bullet_speed * delta * bullet_direction
	
	get_aim_direction(delta)
	
	translate(bullet_movement.normalized() * bullet_speed)
	
	if bullet_life >= 100:
		
		queue_free()

func get_aim_direction(delta):
	
#	if !aiming_down or !aiming_up:
#
#		$Missle_rotate.play("reset_missles")
	
	#checking if we are aiming up
	if aiming_up and bullet_direction == -1:
		
		$Missle_rotate.play("Rot_Up")
		bullet_movement.y = bullet_speed * delta * bullet_direction
		
	if aiming_up and bullet_direction == 1:
		
		$Missle_rotate.play("Rot_Down")
		bullet_movement.y = bullet_speed * delta * -bullet_direction
		
	#checking if we are aiming down
	if aiming_down and bullet_direction == -1:
		
		$Missle_rotate.play("Rot_Down")
		bullet_movement.y = bullet_speed * delta * -bullet_direction
		
	if aiming_down and bullet_direction == 1:
		
		$Missle_rotate.play("Rot_Up")
		bullet_movement.y = bullet_speed * delta * bullet_direction
		
		
func _on_body_entered(body):
	
	if !body.name == "Player":
		
		queue_free()


func _on_area_entered(_area):
	
	queue_free()
