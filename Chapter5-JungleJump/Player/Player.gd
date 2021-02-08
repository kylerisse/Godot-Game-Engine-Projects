extends KinematicBody2D

export (int) var run_speed
export (int) var jump_speed
export (int) var gravity


enum {IDLE, RUN, JUMP, HURT, DEAD}
var state
var anim
var new_anim


func _ready():
	change_state(IDLE)


func change_state(new_state):
	state = new_state
	match state:
		IDLE:
			new_anim = "idle"
		RUN:
			new_anim = "RUN"
		HURT:
			new_anim = "hurt"
		JUMP:
			new_anim = "jump_up"
		DEAD:
			hide()


func _physics_process(delta):
	if new_anim != anim:
		anim = new_anim
		$AnimationPlayer.play(anim)
