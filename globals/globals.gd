extends Node
var total_score = 0
var noisemaker = AudioStreamPlayer2D.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	add_child(noisemaker)
	noisemaker.volume_db = -40
	noisemaker.stream = preload("uid://c25blrywtcckl")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func any_button_pressed():
	noisemaker.play()
