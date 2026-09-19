extends Area2D
class_name Invader
@onready var animated_sprite_2d: AnimatedSprite2D = $InvaderSprite
var invadertype = 10
@onready var explosion_sprite: AnimatedSprite2D = $ExplosionSprite
signal invader_destroyed(points)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var typ = str(invadertype)+"ptalien"
	animated_sprite_2d.play(typ)
	explosion_sprite.visible = false
	explosion_sprite.stop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_entered(area: Area2D) -> void:
	if area is Laser:
		var enemy_explosion = load("res://sounds/enemy_explosion.mp3")
		%InvaderNoisemaker.stream = enemy_explosion
		%InvaderNoisemaker.play()
		area.queue_free()
		animated_sprite_2d.visible = false
		animated_sprite_2d.stop()
		explosion_sprite.visible = true
		explosion_sprite.play()
		await get_tree().create_timer(0.5).timeout
		queue_free()
		invader_destroyed.emit(invadertype)
