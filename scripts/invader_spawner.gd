extends Node2D
class_name InvaderSpawner
const HORIZSPACE = 32
const VERTSPACE = 32
const STARTY = 50
const START_X = 200
const INVADERPOSX = 10
const INVADERPOSY = 20
const INVADER_WIDTH = 24
var c_spawn_position = 50
var rows = 1 # 5
var cols = 1 # 10
var first_round = true
var movedirection = 1
var invader = preload("uid://dglr23iebb666")
var invaderLaser = preload("res://scenes/enemy_laser.tscn")
var destroyedInvaderCount = 0
var totalCount = rows * cols
var spawner_pos
var aln_types: Array = [10, 20, 50]
@onready var move_timer: Timer = $MoveTimer
@onready var shoot_timer: Timer = $ShootTimer
signal inv_destroyed(points)
#@onready var animated_sprite_2d: AnimatedSprite2D = $InvaderSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawner_pos = global_position
	shoot_timer.timeout.connect(shootLaser)
	move_timer.timeout.connect(moveInvaders)
	spawnInvaders()

func spawnInvader(pos:Vector2, type:int):
	var inv = invader.instantiate() as Invader
	inv.invadertype = type
	inv.global_position = pos
	add_child(inv)
	inv.invader_destroyed.connect(onInvaderDestroyed)

func moveInvaders():
	position.x += INVADERPOSX * movedirection

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_left_wall_area_entered(area: Area2D) -> void:
	if area is Invader:
		if movedirection == -1:
			movedirection = 1
			position.y += INVADERPOSY

func _on_right_wall_area_entered(area: Area2D) -> void:
	if area is Invader:
		if movedirection == 1:
			movedirection = -1
			position.y += INVADERPOSY

func spawnInvaders():
	# Is there a way to have these spawn one row at a time?
	%InvaderSpawner.global_position = spawner_pos
	totalCount = rows * cols
	destroyedInvaderCount = 0
	movedirection = 1
	for row in rows:
		# var rowwidth = (COLS * 24 * 1.5) + ((COLS - 1) * HORIZSPACE)
		var startx = START_X #+ (position.x-rowwidth)/2
		var randomNum = randi_range(3, 6)
		var w1 = randomNum * INVADER_WIDTH
		var w2 = randomNum * HORIZSPACE
		var w3 = (w1 + w2) /2
		var w4 = get_viewport_rect().size.x / 2
		c_spawn_position = w4 - w3 
		if first_round == false: #BKM 68-74
			totalCount = cols # Any suggestions? The totalCount is
			cols = randomNum * 2 + 1 # causing invaders to spawn
			totalCount += cols # too early, but I'm not sure
			# how to fix it other than this.
			# This is also causing a bug with the ShootTimer where
			# it tries to shoot while there's no invaders left
			# and crashes the game.
		for col in cols:
			if rows > 3:
				var x = c_spawn_position
				var y = STARTY + (row * 24 ) + (row * VERTSPACE)
				var type = 10
				if row == 0:
					type = 50
				elif row <3:
					type = 20
				spawnInvader(Vector2(x, y), type)
			elif rows == 3:
				var x = c_spawn_position
				var y = STARTY + (row * 24 ) + (row * VERTSPACE)
				var type = 10
				if row == 0:
					type = 50
					spawnInvader(Vector2(x, y), type)
				elif row == 1:
					type = 20
					spawnInvader(Vector2(x, y), type)
				else:
					spawnInvader(Vector2(x, y), aln_types.pick_random())
			else:
				var x = c_spawn_position
				var y = STARTY + (row * 24 ) + (row * VERTSPACE)
				# var type: int = aln_types.pick_random()
				spawnInvader(Vector2(x, y), aln_types.pick_random())
		await get_tree().create_timer(0.2).timeout
	move_timer.autostart = true
	move_timer.start()
	shoot_timer.start()
	if first_round == true:
		first_round = false
	rows = randi_range(1, 5)
	cols = randi_range(7, 12)


func shootLaser():
	var invaderGroup = get_children().filter(func(c): return c is Invader)
	if invaderGroup:
		var shootInvader = invaderGroup.pick_random()
		var shot = invaderLaser.instantiate() as enemyLaser
		shot.global_position = shootInvader.global_position
		var noise = load("res://sounds/enemy_laser.mp3")
		%InvaderShootNoisemaker.stream = noise
		%InvaderShootNoisemaker.play()
		get_tree().root.add_child(shot)

func onInvaderDestroyed(points):
	inv_destroyed.emit(points)
	destroyedInvaderCount += 1
	if destroyedInvaderCount >= totalCount:
		movedirection = 0
		shoot_timer.stop()
		await get_tree().create_timer(0.5).timeout
		spawnInvaders()
