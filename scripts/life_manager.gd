extends Node
class_name LifeManager
@export var lives = 3
@onready var player: Player = $"../Player"
var playerScene = preload("res://scenes/player.tscn")
@onready var lives_display: Sprite2D = $"../GameDisplay/Control/MarginContainer/LivesDisplay"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.playerDestroyed.connect(on_player_destroyed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func on_player_destroyed():
	lives -= 1
	if lives > 0:
		player = playerScene.instantiate()
		player.global_position = Vector2(577, 619)
		player.playerDestroyed.connect(on_player_destroyed)
		get_tree().root.get_node("Main").add_child(player)
		if lives > 1:
			var noise = load("res://sounds/second_life_lost.mp3")
			%LifeManagerNoisemaker.stream = noise
			%LifeManagerNoisemaker.play()
			lives_display.texture = load("res://images/CrackedHeart.png")
		else:
			var noise = load("res://sounds/last_life_lost.mp3")
			%LifeManagerNoisemaker.stream = noise
			%LifeManagerNoisemaker.play()
			lives_display.texture = load("res://images/HalfHeart.png")
	else:
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
