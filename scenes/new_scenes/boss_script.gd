extends CharacterBody2D

#need animation to stop at open
#Need boss to stop for a few sconds to allow player to hit

@export var boss_name = ""
@export var health = 15
@export var power = 25

var knock_back_strength = 700.0

var speed = 3000

var movement = Vector2()

var has_stopped = false


func _ready():
	
	get_node("spore_anim").stop()
	
func _physics_process(delta):
	
	attacking_player()
	
	if GlobalData.boss_awakened[boss_name]:
		
		boss_movement(delta)
		change_direction()
		animation_loop()
		
		
func check_health():
	
	if health <= 0:
		
		GlobalData.boss_defeated[boss_name] = true
		get_parent().get_node("AP").stop() #audio_player
		queue_free()
		
func animation_loop():
	
	if !has_stopped:
		
		get_node("spore_anim").play("open_mouth")
		
func change_direction():
	
	if is_on_wall() or is_on_floor() or is_on_ceiling():
		
		
		movement.x = randi_range(-1,1)
		movement.y = randi_range(-1,1)
		
func boss_movement(delta):
	
	velocity.x = movement.x  * speed * delta
	velocity.y = movement.y * speed * delta
	
	move_and_slide()

func attacking_player():
	
	var check_bodies = get_node("Spore_Sprite/Area2D").get_overlapping_bodies()
	
	for x in check_bodies:
	
		if x.is_in_group("Player"):
			
			var get_direction = global_position.direction_to(x.global_position)
			var apply_knockback = get_direction * knock_back_strength
			
			if apply_knockback.y >= 0 :
				
				apply_knockback.y = apply_knockback.y * -1
				
			x.get_damage(power)
			x.knock_back = apply_knockback


func _on_spore_anim_animation_finished(anim_name):
	
	#keeps mouth open 
	
	if anim_name == "open_mouth":
		has_stopped = true
		get_node("spore_anim").play("stopped_mouth_open")
		
	if anim_name == "stopped_mouth_open":
		has_stopped = true
		get_node("spore_anim").play_backwards("closing_mouth_animation")
	
	
func _on_area_2d_area_entered(area):
	
	if GlobalData.boss_awakened[boss_name] and !area.is_in_group("P_bullets"):
		
		movement.x = randi_range(-1,1)
		movement.y = randi_range(-1,1)
		
		
func _on_area_2d_area_exited(_area):
	
	if GlobalData.boss_awakened[boss_name]:
		
		movement.x = floor(randi_range(-1,1))
		movement.y = floor(randi_range(-1,1))
	


func _on_move_timer_timeout():
	
	#resets movement, so boss can move again/ change direction
	
	if GlobalData.boss_awakened[boss_name]:
		has_stopped = false
		movement.x = randi_range(-1,1)
		movement.y = randi_range(-1,1)

func _on_stop_movement_timeout():
	
	if GlobalData.boss_awakened[boss_name]:
		#stops movement for a time
		has_stopped = true
		movement = Vector2.ZERO


func _on_stem_hb_area_entered(area):
	
	if area.is_in_group("P_bullets"):
		
		health -= area.power
		get_node("change_color").play("took_damage")
		#get_node("spore_anim").play("took_damage")
		check_health()
