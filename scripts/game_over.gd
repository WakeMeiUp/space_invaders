extends Control
@onready var restart_button: Button = $PanelContainer/MarginContainer/VBoxContainer/RestartButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var text_score = str(Globals.total_score)
	%ScoreText.set_text("Total Score: "+text_score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_restart_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	var button_noise = load("res://sounds/button_press.mp3")
	Globals.any_button_pressed()
	#%GameOverNoisemaker.stream = button_noise # BKM - 16-17
	#%GameOverNoisemaker.play() # This is within the scene tree??
