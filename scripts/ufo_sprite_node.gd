extends Area2D
class_name UFO_item
@export var Speed = 200
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var explosion_sprite: AnimatedSprite2D = $ExplosionSprite
var seqno = 0
var shoot_timer = null
var ufoLaser = preload("res://scenes/enemy_laser.tscn")
@onready var left_wall: Area2D = $/root/Main/Walls/LeftWall
signal ufo_destroyed(points)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.play()
	shoot_timer = Timer.new()
	add_child(shoot_timer)
	shoot_timer.wait_time = 2.0
	shoot_timer.timeout.connect(shootLaser)
	shoot_timer.start()
	left_wall.area_exited.connect(wallEntered)

func shootLaser():
	var shot = ufoLaser.instantiate() as enemyLaser
	shot.global_position = global_position
	get_tree().root.add_child(shot)
	var noise = load("res://sounds/enemy_laser.mp3")
	%UfoNoisemaker2.stream = noise
	%UfoNoisemaker2.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position.x -= Speed * delta

# TODO: Stop UFO explosion from moving
func _on_area_entered(area: Area2D) -> void:
	if area is Laser:
		animated_sprite_2d.visible = false
		explosion_sprite.visible = true
		explosion_sprite.play()
		Speed = 0
		shoot_timer.stop() # stops UFOs from shooting after being shot
		var noise = load("res://sounds/ufo_explosion.mp3")
		%UfoNoisemaker.stream = noise
		%UfoNoisemaker.play()
		await get_tree().create_timer(0.5).timeout
		queue_free()
		ufo_destroyed.emit(70)

func wallEntered(area):
	if area is UFO_item:
		ufo_destroyed.emit(0)
		area.queue_free()
