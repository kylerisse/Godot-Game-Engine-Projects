extends Area2D

export (int) var speed

var tile_size = 64
var can_move = true
var facing = 'down'
var moves = {
	'right': Vector2(1, 0),
	'left': Vector2(-1, 0),
	'up': Vector2(0, -1),
	'down': Vector2(0, 1),
}
onready var raycasts = {
	'right': $RayCastRight,
	'left': $RayCastLeft,
	'up': $RayCastUp,
	'down': $RayCastDown
}

func move(dir):
	$AnimatedSprite.speed_scale = speed
	facing = dir
	if raycasts[facing].is_colliding():
		return
	
	can_move = false
	$AnimatedSprite.animation = facing
	$MoveTween.interpolate_property(self, "position", position,
				position + moves[facing] * tile_size,
				1.0 / speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$MoveTween.start()

	return true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_MoveTween_tween_completed(object, key):
	can_move = true
	$AnimatedSprite.speed_scale = 0
