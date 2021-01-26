extends "res://characters/Character.gd"

var dirs = ['down', 'up', 'left', 'right']

func _ready():

	can_move = false
	facing = dirs[randi() % 4]
	yield(get_tree().create_timer(0.5), 'timeout')
	can_move = true

func _process(delta):
	if can_move:
		if not move(facing) or randi() % 10 > 5:
			facing = dirs[randi() % 4]
