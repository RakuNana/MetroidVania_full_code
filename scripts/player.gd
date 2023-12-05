extends CharacterBody2D

var save_path = OS.get_environment("HOME") +"/Documents/Testing_saves/savemedata.dat"

@onready var loadin_bullets = preload("res://scenes/bullets.tscn")
@onready var loadin_missles = preload("res://scenes/Fire_Missles.tscn")
@onready var get_menu = preload("res://scenes/menu.tscn")

var movement = Vector2()
var bullet_direction = Vector2()
var speed = 100 
var jump_ht = 600
var fall_vel = 5
var current_direction = "Idle"
var is_aiming_up = false 
var is_aiming_down = false
var morphball = false
var can_save = false

var timer_started = false
var timer_count = 0

var menu_opened = false


@onready var  anim = $Samus_anim

@onready var stand_col = $Standing_col
@onready var jump_col = $Jump_col
@onready var has_a_landing1 = $Check_landing
@onready var has_a_landing2 = $Check_landing2
@onready var morphball_col = $Morphball_col
@onready var bullet_marker = $Bullet_exit_pos

var knock_back = Vector2()
var been_hit = false

func _ready():
	
	add_to_group("Player")
	position = PlayerInventory.players_current_pos
	
	
func _physics_process(delta):
	
	current_gravity()
	Player_movement()
	check_current_aim()
	animation_player()
	aim_animations()
	open_menu()
	timer_resetter()
	#remember to add your methods here
	aim_animations_extra()
	Check_morphball_state()
	check_bullet_direction()
	call_save_function()
	
	if has_a_landing1.is_colliding() or has_a_landing2.is_colliding():
		
		stand_col.disabled = false
		jump_col.disabled = true
		
		
	knock_back = lerp(knock_back, Vector2.ZERO, 0.2)
	
	
	movement = movement.normalized() * speed * delta
	move_and_slide()
	
	if Input.is_action_just_pressed("m_key"):
		pass
		#print(PlayerInventory.inventory["Health"])
		#print(PlayerInventory.inventory["Missile"])
		
		
		
func get_damage(amount):
	
	
	if !timer_started:
		
		been_hit = true
		PlayerInventory.inventory["Health"] -= amount
		
	timer_started = true
	
	check_health()
	
func check_health():
	
	if PlayerInventory.inventory["Health"] <= 0:
		
		PlayerInventory.inventory["Health"]= clamp(PlayerInventory.inventory["Health"],0,PlayerInventory.max_health)
		print("Game Over")
		
func timer_resetter():
	
	if timer_started:
		
		timer_count += 1
		
	if timer_count >= 50:
		
		timer_started = false
		timer_count = 0
		
	#print(timer_started," ", timer_count)
		
func call_save_function():
	
	if Input.is_action_just_pressed("load_game") and can_save:
		
		game_save()
		
	if Input.is_action_just_pressed("load_game") and !can_save:
		
		load_game()
		
		
func open_menu():
	
	if Input.is_action_just_pressed("m_key") and !menu_opened:
		
		menu_opened = true
		
		var load_menu = get_menu.instantiate()
	
		load_menu.connect("menu_closed", toggle_menu)
		get_tree().paused = true
		add_child(load_menu)
		
func toggle_menu():
	
	menu_opened = false
	get_tree().paused = false
	
func Player_movement():
	
	var LEFT =Input.is_action_pressed("ui_left")
	var RIGHT =Input.is_action_pressed("ui_right")
	var JUMP =Input.is_action_just_pressed("ui_accept")
	
	var DOWN = Input.is_action_just_pressed("down")
	var UP = Input.is_action_just_pressed("ui_up")
	
	movement.x = -int(LEFT) + int(RIGHT)
	movement.y = -int(JUMP)
	
	
	if been_hit:
		
		velocity.y += knock_back.y
		

	if movement.x != 0:
		
		velocity.x = movement.x * speed + knock_back.x 
		
	else:
		
		velocity.x = 0
		
		
	if JUMP and is_on_floor():
		
		fall_vel -= jump_ht
		
	if DOWN:
		
		morphball = true
		
	if UP:
		
		anim.flip_h = false
		#Added: the morphball_col needs to disable when we aren't in the morphball
		morphball_col.disabled = true
		morphball = false
		
	if Input.is_action_just_pressed("fire_weapon") and current_direction != "Idle" and !morphball:
		
		fire_missles()
		fire_weapon()
		
		
func aim_animations():
	
	#added a check for movement.x, if 0(meaning we aren't moving) play this animation
	if current_direction == "Left" and is_aiming_down and !morphball and movement.x == 0:
		
		anim.play("Aim_Down_L")
		
	if current_direction == "Right" and is_aiming_down and !morphball and movement.x == 0:
		
		anim.play("Aim_Down_R")
		
	if current_direction == "Left" and is_aiming_up and !morphball and movement.x == 0:
		
		anim.play("Aim_Up_L")
		
	if current_direction == "Right" and is_aiming_up and !morphball and movement.x == 0:
		
		anim.play("Aim_Up_R")
		
		
func aim_animations_extra():
	
	#These are the run and aim animations, the are triggered when both aim and movement are true!
	if current_direction == "Left" and is_aiming_down and !morphball and movement.x == -1:
		
		anim.play_backwards("RL_Aim_Down")
		
	if current_direction == "Right" and is_aiming_down and !morphball and movement.x == 1:
		
		anim.play("RR_Aim_Down")
		
	if current_direction == "Left" and is_aiming_up and !morphball and movement.x == -1:
		
		anim.play_backwards("RL_Aim_Up")
		
	if current_direction == "Right" and is_aiming_up and !morphball and movement.x == 1:
		
		anim.play("RR_Aim_Up")
		
func check_current_aim():
	
	if Input.is_action_pressed("ui_page_up"):

		is_aiming_up = true
		
	if Input.is_action_pressed("ui_page_down"):
		
		is_aiming_down = true
		
	if Input.is_action_just_released("ui_page_up") or Input.is_action_just_released("ui_page_down"):
		
		is_aiming_up = false 
		is_aiming_down = false
		
func check_bullet_direction():
	
	if current_direction == "Left":
		
		bullet_marker.position = Vector2(-13,-8)
		bullet_direction.x = -1
		
	if current_direction == "Right":
		
		bullet_marker.position = Vector2(20,-8)
		bullet_direction.x = 1
		
	if current_direction == "Left" and is_aiming_up:
		bullet_marker.position = Vector2(-10,-18)
		
	if current_direction == "Left" and is_aiming_down:
		bullet_marker.position = Vector2(-8,6)
		
	if current_direction == "Right" and is_aiming_up:
		bullet_marker.position = Vector2(16,-18)
		
	if current_direction == "Right" and is_aiming_down:
		bullet_marker.position = Vector2(15,6)
		
	
		
		
func Check_morphball_state():
	
	if morphball:
		
		stand_col.disabled = true
		jump_col.disabled = true
		morphball_col.disabled = false
		has_a_landing1.enabled = false
		has_a_landing2.enabled = false
		
	else:
		
		has_a_landing1.enabled = true
		has_a_landing2.enabled = true
		

func animation_player():
	
	if movement.x == -1:
		
		#Not needed anymore, spritesheet has been fixed
		#stand_col.position = Vector2(4,1)
		current_direction = "Left"
		
	if movement.x == 1:
		
		#Not needed anymore, spritesheet has been fixed
		#stand_col.position = Vector2(-1,1)
		current_direction = "Right"
			
			
	if movement.x == -1 and !is_on_floor():
		
		jump_col.disabled = false
		stand_col.disabled = true
		anim.play("SummerSault_Left")
		
	if movement.x == 1 and !is_on_floor():
		
		jump_col.disabled = false
		stand_col.disabled = true
		anim.play("SummerSault_Right")
			
			
	check_direction()
			
func check_direction():
			
	if !morphball:
			
		if current_direction == "Left" and is_on_floor() and !morphball and !is_aiming_up and !is_aiming_down:
			
			anim.play_backwards("Run_L")
			
		if current_direction == "Right" and is_on_floor() and !morphball and !is_aiming_up and !is_aiming_down:
			
			anim.play("Run_R")
			
		if movement == Vector2.ZERO:
			
			if current_direction == "Left":
				
				anim.play("Idle_Left")
				
			if current_direction == "Right":
				
				anim.play("Idle_Right")
				
				
		if morphball and current_direction == "Left":
			
			anim.play("Morph_ball_L")
			
	else:
		
		if morphball and movement.x == -1:
			
			anim.flip_h = false
			anim.play("Morph_ball_L")
			
		if morphball and movement.x == 1:
			
			anim.flip_h = true
			anim.play("Morph_ball_L")
			
		if morphball and movement == Vector2.ZERO:
			
			anim.play("Morph_ball_L")
			anim.stop()
		
	
	
func current_gravity():
	
	var new_gravity = gravity_force.new()
	
	velocity.y = fall_vel
	
	if !is_on_floor():
		
		fall_vel += new_gravity.gravity_str
		
	if is_on_floor() and fall_vel > 5:
		
		fall_vel = 5
		
	if fall_vel >= new_gravity.terminal_vel:
		
		fall_vel = new_gravity.terminal_vel
		
	#print(fall_vel)
	
func fire_weapon():
	
	if !Input.is_action_pressed("ready_missles"):
		
		var get_bullets = loadin_bullets.instantiate()
		
		if current_direction == "Left":
			
			get_bullets.check_direction(bullet_direction.x)
			
		if current_direction == "Right":
			
			get_bullets.check_direction(bullet_direction.x)
			
		
		get_parent().add_child(get_bullets)
		get_bullets.is_currently_aiming_up(is_aiming_up)
		get_bullets.is_currently_aiming_down(is_aiming_down)
		
		get_bullets.position = bullet_marker.global_position
		
func fire_missles():
	
	if Input.is_action_pressed("ready_missles") and PlayerInventory.inventory["Missile"].has("Missile"):
		
		var get_missles = loadin_missles.instantiate()
		
		PlayerInventory.inventory["Missile"].pop_front()
		
		get_missles.add_to_group("Missiles_group")
		
		if current_direction == "Left":
			
			get_missles.check_direction(bullet_direction.x)
			
		if current_direction == "Right":
			
			get_missles.check_direction(bullet_direction.x)
			
		
		get_parent().add_child(get_missles)
		get_missles.is_currently_aiming_up(is_aiming_up)
		get_missles.is_currently_aiming_down(is_aiming_down)
		
		get_missles.position = bullet_marker.global_position
		
		
func game_save():
	
	var data = {
		
		"filename" : get_parent().get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : self.position.x,
		"pos_y" : self.position.y,
		"max_missiles" : PlayerInventory.max_missiles,
		"current_ammo" : PlayerInventory.inventory["Missile"],
		"Items_collected" : PlayerInventory.item_tracker["Missiles_pickup"],
		"jar_pickles" : 12,
		"current_room" : PlayerInventory.current_room
		
	}
	
	var get_file = FileAccess.open(save_path,FileAccess.WRITE)
	get_file.store_var(data)
	get_file.close()
	
	
func load_game():
	
	var get_load = FileAccess.open(save_path,FileAccess.READ)
	
	if FileAccess.file_exists(save_path):
		
		FileAccess.open(save_path,FileAccess.READ)
		var player_data = get_load.get_var()
		
		get_tree().change_scene_to_file(player_data["filename"])
		
		PlayerInventory.players_current_pos.x = player_data["pos_x"]
		PlayerInventory.players_current_pos.y = player_data["pos_y"]
		
		PlayerInventory.inventory["Missile"] = player_data["current_ammo"]
		PlayerInventory.item_tracker["Missiles_pickup"] = player_data["Items_collected"]
		
		get_load.close()
