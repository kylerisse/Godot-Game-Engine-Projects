extends RigidBody2D

enum States {INIT, ALIVE, INVULNERABLE, DEAD}
const INIT = 0
const ALIVE = 1
const INVULNERABLE = 2
const DEAD = 3

var state = null

export (int) var engine_power
export (int) var spin_power

var thrust = Vector2()
var rotation_dir = 0

func _ready():
	change_state(ALIVE)
	
func _process(_delta):
	get_input()
	
func _physics_process(_delta):
	set_applied_torque(spin_power * rotation_dir)
	set_applied_force(thrust.rotated(rotation))
	


func change_state(new_state):
	match new_state:
		INIT:
			$CollisionShape2D.disabled = true
		ALIVE:
			$CollisionShape2D.disabled = false
		INVULNERABLE:
			$CollisionShape2D.disabled = true
		DEAD:
			$CollisionShape2D.disabled = true
	state = new_state

func get_input():
	thrust = Vector2()
	if state in [DEAD, INIT]:
		return
	if Input.is_action_pressed('thrust'):
		thrust = Vector2(engine_power, 0)
	rotation_dir = 0
	if Input.is_action_pressed('rotate_right'):
		rotation_dir += 1
	if Input.is_action_pressed('rotate_left'):
		rotation_dir -= 1
