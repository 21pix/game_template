extends CharacterBody3D
class_name FPS_player

@export var equip = Resource

@export var movement_velocity: Vector3
@export var slow_walk_speed = 2
@export var walk_speed = 4
@export var run_speed = 7
@export var jump_strength = 8
@export var gravity := 0.0
@export var velocity_mult = 200
@onready var interact_ray: RayCast3D = $Head/Camera/InteractDetect/InteractRay
@onready var interact_detect: Area3D = $Head/Camera/InteractDetect

@onready var inventory_main: Inventorymain = $InventoryMain

@export var invert_weapon_sway : bool = false

@export var bob_amount_walk : float = 0.05
@export var bob_amount_run : float = 0.07
@export var bob_amount_slow_walk : float = 0.03
@export var bob_amount_crouch : float = 0.015

@export var bob_freq_slow_walk : float = 0.009
@export var bob_freq_walk : float = 0.015
@export var bob_freq_run : float = 0.019

@export_subgroup("Input")

@export var mouse_sensitivity = 700
@export var gamepad_sensitivity := 0.075
var mouse_captured := true
var rotation_target: Vector3
var input_mouse: Vector2
var health:int = 100
var previously_floored := false
var jump_single := true
var def_weapon_holder_pos : Vector3
var walk: bool = true
var run: bool = false
var slow_walk: bool = false
var crouch: bool = false
var can_run: bool = true
var move_speed

signal player_hit
signal health_updated

@onready var player: CharacterBody3D = $"."

@onready var worldcoll: CollisionShape3D = $CollisionWithWorld
@onready var wallcoll: CollisionShape3D = $CollisionWithWalls

@onready var head = $Head
@onready var Ftimer = $PlayerAudio/FootstepFreq
@onready var camera = $Head/Camera
@onready var PlayerStream = $PlayerAudio/PlayerStream
@onready var WeaponContainer = $Head/Camera/WeaponContainer
@onready var wCont = get_node("Head/Camera/WeaponContainer")
@onready var crosshair: TextureRect = $HUD/Crosshair

var weapon: WeaponClass

@onready var player_hit_rect: TextureRect = $HUD/PlayerHitRect


func _ready():
	Globals.connect("add_health", add_health)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta):
# Handle functions
	
	handle_controls(delta)
	handle_gravity(delta)
	weapon_bob(velocity.length(),delta)
# STEALTH LEVEL 

	if velocity.length() > 2.0:
		Globals.emit_signal("stealth_off")

	if velocity.length() < 2.0:
		Globals.emit_signal("stealth_on")
	
# Movement
	
	movement_velocity = transform.basis * movement_velocity # Move forward
	
	var applied_velocity: Vector3
	applied_velocity = velocity.lerp(movement_velocity, delta * 10)
	applied_velocity.y = -gravity
	
	velocity = applied_velocity
	WeaponContainer.position = lerp(WeaponContainer.position, wCont.WeaponContainer_offset - (basis.inverse() * applied_velocity / velocity_mult), delta * 10)

	
	move_and_slide()
	


# Walking sound
	if is_on_floor():
		if abs(velocity.x) > 1 or abs(velocity.z) > 1:
			if Ftimer.time_left <= 0:
				PlayerStream.pitch_scale = randf_range(0.8, 1.2)
				PlayerStream.play()
				if walk == true:
					Ftimer.start(0.4)
					PlayerStream.volume_db = -10
				if run == true:
					Ftimer.start(0.32)
					PlayerStream.volume_db = -8.0
				if slow_walk == true:
					PlayerStream.volume_db = -12.0
					Ftimer.start(0.7)
				if crouch == true:
					PlayerStream.volume_db = -14.0
					Ftimer.start(0.7)
# Landing after jump or falling
	
	camera.position.y = lerp(camera.position.y, 0.0, delta * 5)
	
	if is_on_floor() and gravity > 1 and !previously_floored: # Landed
		Audio.play("assets/sounds/player/land.ogg")
		camera.position.y = -0.1
	
	previously_floored = is_on_floor()
	
# Falling/respawning
	
	#if position.y < -10:
	#	get_tree().reload_current_scene()
# Rotation

	camera.rotation.z = lerp_angle(camera.rotation.z, -input_mouse.x * 5 * delta, delta * 30)	# 5 is cam tilt factor
	
	camera.rotation.x = lerp_angle(camera.rotation.x, rotation_target.x, delta * 25)
	rotation_target.x = clamp(rotation_target.x, deg_to_rad(-90), deg_to_rad(90))
	rotation.y = lerp_angle(rotation.y, rotation_target.y, delta * 25)
# Mouse movement

func _input(event):
	if event is InputEventMouseMotion and mouse_captured:
		
		input_mouse = event.relative / mouse_sensitivity
		
		rotation_target.y -= event.relative.x / mouse_sensitivity
		rotation_target.x -= event.relative.y / mouse_sensitivity

func handle_controls(_delta):
	
# Mouse capture
	
#	if Input.is_action_just_pressed("mouse_capture"):
#		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
#		mouse_captured = true
		
	if Input.is_action_just_released("inventory"):
		
		if !GlobalsPlayer.inventory_player_on :
			if !GlobalsPlayer.chest_available:
				inventory_main.open_player_inventory()
				mouse_captured = false
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
				crosshair.visible = false
				
			elif GlobalsPlayer.chest_available:
				print("open inv 2")
				Globals.emit_signal("interact")
				interact_detect.interact()
				inventory_main.open_both_inventory()
				mouse_captured = false
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
				crosshair.visible = false		
					
		elif GlobalsPlayer.inventory_player_on:
			inventory_main.close_both_inventory()
			mouse_captured = true
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			crosshair.visible = true
				
	
# INTERACT

	if Input.is_action_just_released("interact"):
		if Globals.item_detected:
			Globals.emit_signal("interact")
			interact_detect.interact() # If Player overlaps with item coll box > 
		if !Globals.item_detected:
			return
		# FIX THIS ::


# EXIT GAME		
	if Input.is_action_pressed("exit"):
		get_tree().quit()
		
		input_mouse = Vector2.ZERO
		
# SLOW WALK

	if Input.is_action_pressed("SlowWalk"):
		move_speed = slow_walk_speed
		walk = false
		run = false
		slow_walk = true
		crouch = false
		
		
	else :
		move_speed = walk_speed
		walk = true
		run = false
		slow_walk = false
		crouch = false
		
# CROUCH
	if Input.is_action_pressed("crouch"):
		move_speed = slow_walk_speed
		walk = false
		run = false
#		slow_walk = true
		crouch = true
		action_crouch_alt()

	
	if Input.is_action_just_released("crouch"):
		crouch = false
		action_crouch_out_alt()
		
# RUN

	if Input.is_action_pressed("run"):
		if can_run:
			move_speed = run_speed
			walk = false
			run = true
			slow_walk = false
			crouch = false
		
		
	else :
		if !slow_walk and !crouch:
			move_speed = walk_speed
			walk = true
			run = false
			slow_walk = false
			crouch = false
# Jumping
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		Audio.play("assets/sounds/player/jump_a.ogg, assets/sounds/player/jump_b.ogg, assets/sounds/player/jump_c.ogg")
		action_jump()	
		
# Movement
	if !GlobalsNpc.dial_no_move:
		var input := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
		movement_velocity = Vector3(input.x, 0, input.y).normalized() * move_speed
		
func action_crouch_alt():
	can_run = false
#	head.transform.origin.y = -1
	
	var Headcrouch = 0.9
	var tween_crouchIn = create_tween()
	tween_crouchIn.set_ease(Tween.EASE_IN)
	tween_crouchIn.tween_property(head, "transform:origin:y", Headcrouch, 0.3)
		
	worldcoll.transform.origin.y = 0.659
	worldcoll.scale.y = 0.45
	wallcoll.transform.origin.y = 0.9
	
func action_crouch_out_alt():
	can_run = true
	
	var HeadDefault = 1.9
	var tween_crouchout = create_tween()
	tween_crouchout.set_ease(Tween.EASE_IN)
	tween_crouchout.tween_property(head, "transform:origin:y", HeadDefault, 0.3)
	
	worldcoll.transform.origin.y = 1.159
	worldcoll.scale.y = 1
	wallcoll.transform.origin.y = 1.9


func handle_gravity(delta):
	
	gravity += 20 * delta
	
	if gravity > 0 and is_on_floor():
		
		jump_single = true
		gravity = 0

# Jumping

func action_jump():
	
	gravity = -jump_strength
	
func weapon_bob(vel : float, delta):
#	if WeaponContainer:

		
	if vel > 1 and is_on_floor():
		if walk == true: 	
			WeaponContainer.position.y = lerp(WeaponContainer.position.y, def_weapon_holder_pos.y + sin(Time.get_ticks_msec() * bob_freq_walk) * bob_amount_walk, 2 * delta)
			WeaponContainer.position.x = lerp(WeaponContainer.position.x, def_weapon_holder_pos.x + sin(Time.get_ticks_msec() * bob_freq_walk * 0.5) * bob_amount_walk, 2 * delta)
		if run == true:	
			WeaponContainer.position.y = lerp(WeaponContainer.position.y, def_weapon_holder_pos.y + sin(Time.get_ticks_msec() * bob_freq_run) * bob_amount_run, 2 * delta)
			WeaponContainer.position.x = lerp(WeaponContainer.position.x, def_weapon_holder_pos.x + sin(Time.get_ticks_msec() * bob_freq_run * 0.5) * bob_amount_run, 2 * delta)
		if slow_walk == true:	
			WeaponContainer.position.y = lerp(WeaponContainer.position.y, def_weapon_holder_pos.y + sin(Time.get_ticks_msec() * bob_freq_slow_walk) * bob_amount_slow_walk, 2 * delta)
			WeaponContainer.position.x = lerp(WeaponContainer.position.x, def_weapon_holder_pos.x + sin(Time.get_ticks_msec() * bob_freq_slow_walk * 0.5) * bob_amount_slow_walk, 2 * delta)
		if crouch == true:	
			WeaponContainer.position.y = lerp(WeaponContainer.position.y, def_weapon_holder_pos.y + sin(Time.get_ticks_msec() * bob_freq_slow_walk) * bob_amount_crouch, 2 * delta)
			WeaponContainer.position.x = lerp(WeaponContainer.position.x, def_weapon_holder_pos.x + sin(Time.get_ticks_msec() * bob_freq_slow_walk * 0.5) * bob_amount_crouch, 2 * delta)
	else:
		WeaponContainer.position.y = lerp(WeaponContainer.position.y, def_weapon_holder_pos.y, delta)
		WeaponContainer.position.x = lerp(WeaponContainer.position.x, def_weapon_holder_pos.x, delta)

#-----------------------HEALTH DAMAGE -------------------

func damage(amount):
	
	health -= amount/10 # MUST USE A MULT FROM DIFFICULTY LEVEL
	health_updated.emit(health) # Update health on HUD
#	print("health:", health)
	if health <= 0:
#		var enemy_mob = get_tree().get_nodes_in_group("NPC_unit")
#		if enemy_mob.size()>0:
#			for enemy in enemy_mob:
#				enemy.queue_free()
			get_tree().reload_current_scene() # Reset when out of health

func hit():
	emit_signal("player_hit")

func add_health():
	var boost = 20
	health += boost
	health_updated.emit(health) # Update health on HUD
#	print("health:", health)	
		
