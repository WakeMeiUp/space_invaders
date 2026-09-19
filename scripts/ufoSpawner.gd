extends Node2D
@export var UFOScene:PackedScene
@onready var spawn_timer: Timer = $SpawnTimer
var next_seqno = 1
signal s_ufo_destroyed(points)
var ufo_count = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_timer.wait_time = randi_range(10, 30)
	spawn_timer.start()
	spawn_timer.timeout.connect(spawnUFO)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func spawnUFO():
	ufo_count +=  1
	var UFO = UFOScene.instantiate()
	UFO.seqno = next_seqno
	next_seqno += 1
	UFO.global_position = Vector2.ZERO
	#get_tree().root.add_child(UFO)
	add_child(UFO)
	UFO.ufo_destroyed.connect(ufoDestroyed)
	%UFOAudioPlayer.play()
	spawn_timer.wait_time = randi_range(10, 30)
	spawn_timer.start()

func ufoDestroyed(points):
	s_ufo_destroyed.emit(points)
	ufo_count -= 1
	if ufo_count <= 0:
		%UFOAudioPlayer.stop() # this is causing issues because
		# it doesn't signal destroyed if it hits a wall
