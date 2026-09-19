extends Node2D
@export var laserScene:PackedScene
var laserOut = false
@onready var bullet_catcher: Area2D = $"../../BulletCatcher"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	#bullet_catcher.laserDestroyed.connect(onLaserDestroyed)

func _input(_event):
	if Input.is_action_just_pressed("shootLaser"):
		if laserOut != true:
			laserOut = true
			var ship_explosion = load("res://sounds/bullet_fired.mp3")
			%PlayerNoisemaker.stream = ship_explosion
			%PlayerNoisemaker.play()
			var laser = laserScene.instantiate() as Laser
			laser.global_position = get_parent().global_position - Vector2(0, 20)
			get_tree().root.get_node("Main").add_child(laser)
			laser.tree_exited.connect(onLaserDestroyed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
	
func onLaserDestroyed():
	laserOut = false
