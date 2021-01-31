extends RigidBody2D

signal shoot
signal lives_changed
signal dead

export (PackedScene) var Bullet
export (float) var fire_rate
export (int) var engine_power
export (int) var spin_power

var can_shoot = true
var lives = 0 setget set_lives

enum States {INIT, ALIVE, INVULNERABLE, DEAD}
const INIT = 0
const ALIVE = 1
const INVULNERABLE = 2
const DEAD = 3

var state = null

var screensize = Vector2()

var thrust = Vector2()
var rotation_dir = 0

func _ready():
	screensize = get_viewport().get_visible_rect().size
	change_state(ALIVE)
	$GunTimer.wait_time = fire_rate

func start():
	$Sprite.show()
	self.lives = 3
	change_state(ALIVE)

func _process(_delta):
	get_input()
	
func shoot():
	if state == INVULNERABLE:
		return
	emit_signal('shoot', Bullet, $Muzzle.global_position, rotation)
	can_shoot = false
	$GunTimer.start()
	
func _integrate_forces(physics_state):
	set_applied_torque(spin_power * rotation_dir)
	set_applied_force(thrust.rotated(rotation))
	
	var xform = physics_state.get_transform()
	if xform.origin.x > screensize.x:
		xform.origin.x = 0
	if xform.origin.x < 0:
		xform.origin.x = screensize.x
	if xform.origin.y > screensize.y:
		xform.origin.y = 0
	if xform.origin.y < 0:
		xform.origin.y = screensize.y
	physics_state.set_transform(xform)

func change_state(new_state):
	match new_state:
		INIT:
			$CollisionShape2D.disabled = true
			$Sprite.modulate.a = 0.5
		ALIVE:
			$CollisionShape2D.disabled = false
			$Sprite.modulate.a = 1.0
		INVULNERABLE:
			$CollisionShape2D.disabled = true
			$Sprite.modulate.a = 0.5
			$InvulnerabilityTimer.start()
		DEAD:
			$CollisionShape2D.disabled = true
			$Sprite.hide()
			linear_velocity = Vector2()
			emit_signal('dead')
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
	if Input.is_action_pressed('shoot') and can_shoot:
		shoot()

func set_lives(value):
	lives = value
	emit_signal('lives_changed', lives)

func _on_GunTimer_timeout():
	can_shoot = true

func _on_InvulnerabilityTimer_timeout():
	change_state(ALIVE)

func _on_Player_body_entered(body):
	if body.is_in_group('rocks'):
		body.explode()
		$Explosion.play('explosion')
		self.lives -= 1
		if lives < 0:
			change_state(DEAD)
		else:
			change_state(INVULNERABLE)
