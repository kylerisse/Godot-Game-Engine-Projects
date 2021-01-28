extends 'res://characters/Character.gd'

signal moved
signal dead
signal grabbed_red_key
signal grabbed_green_key
signal win

func _ready():
	$AnimatedSprite.animation = 'down'
	$AnimatedSprite.frame = 0

func _process(delta):
	if can_move:
		if Input.is_action_pressed('ui_down'):
			if move('down'):
				emit_signal('moved')
		if Input.is_action_pressed('ui_up'):
			if move('up'):
				emit_signal('moved')
		if Input.is_action_pressed('ui_left'):
			if move('left'):
				emit_signal('moved')
		if Input.is_action_pressed('ui_right'):
			if move('right'):
				emit_signal('moved')


func _on_Player_area_entered(area):
	if area.is_in_group('enemies'):
		emit_signal('dead')
	if area.has_method('pickup'):
		area.pickup()
		if area.type == 'key_red':
			emit_signal('grabbed_red_key')
		if area.type == 'key_green':
			emit_signal('grabbed_green_key')
		if area.type == 'star':
			emit_signal('win')
