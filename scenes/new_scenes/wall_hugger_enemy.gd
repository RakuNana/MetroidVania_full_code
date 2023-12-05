extends CharacterBody2D

@onready var enemy_projectile = preload("res://scenes/new_scenes/enemy_pin.tscn")

@export var damage_amount = 0
@export var health  = 3
@export var speed = 2000

@onready var c_left = $Sprite_pivot/Sprite2D/enemy_eyes/Check_left
@onready var c_right = $Sprite_pivot/Sprite2D/enemy_eyes/Check_right

@onready var c_walkable_left = $Sprite_pivot/Sprite2D/enemy_eyes/Check_ceiling_left
@onready var c_walkable_right = $Sprite_pivot/Sprite2D/enemy_eyes/Check_ceiling_right

var fall_vel = 5

enum {LEFT,LU,UP,RU,RIGHT,DOWN}
var dir_list = [LEFT,LU,UP,RU,RIGHT]

var move_direction  = 0

var can_see_player = false
var start_timer = false

var can_see_timer = 0

var dir_x = 0
var dir_y = 0
var knock_back_strength = 700.0


func _ready():
	
	add_to_group("enemy")
	
func _physics_process(delta):
	
	check_timer()
	enemy_movement(delta)
	add_gravity()
	shoot_at_player()
	change_movement()
	wall_hugger_animation()
	
	#This fixes triggering issue
	var eye = get_node("Sprite_pivot/Sprite2D/enemy_eyes").get_overlapping_bodies()
	
	for x in eye:
		
		if x.is_in_group("Player"):
			
			can_see_player = true
			
			
func wall_hugger_animation():
	
	$Sprite_pivot/Sprite2D.play("small_en_walk")
			
func change_movement():
	
	if c_left.is_colliding():
		
		move_direction = RIGHT
		
	if c_right.is_colliding():
		
		move_direction = LEFT
		
	if !c_walkable_left.is_colliding():
		
		move_direction = RIGHT
		
	if !c_walkable_right.is_colliding():
		
		move_direction = LEFT
		
	
func enemy_movement(delta):
	
	velocity.x = speed * delta
	
	if move_direction == RIGHT:
		
		velocity.x = speed * delta
		
	if move_direction == LEFT:
		
		velocity.x = -speed * delta
		
	move_and_slide()
	
func add_gravity():
	
	var new_gravity = gravity_force.new()
	
	velocity.y = fall_vel
	
	if !is_on_floor():
		
		fall_vel += new_gravity.gravity_str
		
	if is_on_floor() and fall_vel > 5:
		
		fall_vel = 5
		
	if fall_vel >= new_gravity.terminal_vel:
		
		fall_vel = new_gravity.terminal_vel
	
func check_health():
	
	if health <= 0:
		
		queue_free()
	
func check_direction(current_direction):
	
	var new_dir = dir_list[current_direction]
	
	if new_dir == LEFT:
		
		dir_x = -1
		dir_y = 0
		
	if new_dir == LU:
		
		dir_x = -1
		dir_y = -1
		
	if new_dir == UP:
		
		dir_x = 0
		dir_y = -1
		
	if new_dir == RU:
		
		dir_x = 1
		dir_y = -1
		
	if new_dir == RIGHT:
		
		dir_x = 1
		dir_y = 0
		
func shoot_at_player():
	
	if can_see_player and !start_timer:
		
		start_timer = true
		
		for x in range(dir_list.size()):
			
			var new_projectiles = enemy_projectile.instantiate()
			get_parent().add_child(new_projectiles)
			
			new_projectiles.global_position = get_node("Sprite_pivot").global_position
			#new_projectiles.rotation = get_node("Sprite_pivot").rotation
			
			check_direction(x)
			new_projectiles.get_direction(dir_x,dir_y)
			
func check_timer():
	
	if start_timer:
		
		can_see_timer += 1
		
	if can_see_timer >= 150:
		
		can_see_timer = 0
		start_timer = false
		
func _on_hit_box_area_entered(area):
	
	if area.is_in_group("P_bullets"):
		
		health -= area.power
		check_health()
		
		
func _on_enemy_eyes_body_exited(body):
	
	if body.is_in_group("Player"):
		
		can_see_player = false
		print("Where the hell do you think you're going!")
		
		
func _on_hit_box_body_entered(body):
	
	if body.is_in_group("Player"):
		
		var get_direction = global_position.direction_to(body.global_position)
		var apply_knockback = get_direction * knock_back_strength
		
		if apply_knockback.y >= 0 :
			
			apply_knockback.y = apply_knockback.y * -1
			
		body.get_damage(damage_amount)
		body.knock_back = apply_knockback
