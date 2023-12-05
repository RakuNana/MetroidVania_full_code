extends CanvasLayer

signal menu_closed

@onready var add_missile_pack = preload("res://scenes/Add_to_inventory.tscn")

func _ready():
	
	add_missiles()
	
func add_missiles():
	
	if PlayerInventory.item_tracker["Missiles_pickup"].size() > 0:
		
		var load_missiles_to_menu = add_missile_pack.instantiate()
		
		get_node("Button").connect("in_map", hide_upgrade_icons)
		
		load_missiles_to_menu.position = $Marker2D.global_position
		add_child(load_missiles_to_menu)

func _physics_process(_delta):
	
	exit_menu()
	
func exit_menu():
	
	if Input.is_action_just_pressed("m_key"):
		
		emit_signal("menu_closed")
		queue_free()
		
		
func hide_upgrade_icons():
	
	self.hide()
		
