extends Control
@onready var animated_sprite_2d: AnimatedSprite2D = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer3/AnimatedSprite2D
@onready var animated_sprite_2d_2: AnimatedSprite2D = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/AnimatedSprite2D2
@onready var animated_sprite_2d_3: AnimatedSprite2D = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/AnimatedSprite2D3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.play("default")
	animated_sprite_2d_2.play("new_animation")
	animated_sprite_2d_3.play("new_animation_1")

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	var noise = load("res://sounds/button_press.mp3")
	Globals.any_button_pressed()
	#%StartMenuNoisemaker.stream = noise #BKM
	#%StartMenuNoisemaker.play() # Another error, see game over area
