extends Area2D

signal shoot

export (PackedScene) var Bullet
export (int) var speed = 150
export (int) var health = 3

var follow
var target = null


func shoot():
	$ShootSound.play()
	var dir = target.global_position - global_position
	dir = dir.rotated(rand_range(-0.1, 0.1)).angle()
	emit_signal('shoot', Bullet, global_position, dir)


func shoot_pulse(n, delay):
	$AnimationPlayer.play('shooting')
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play('rotate')
	for _i in range(n):
		shoot()
		yield(get_tree().create_timer(delay), 'timeout')


func take_damage(amount):
	health -= amount
	$AnimationPlayer.play('flash')
	if health <= 0:
		explode()
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play('rotate')


func explode():
	$ExplodeSound.play()
	speed = 0
	$GunTimer.stop()
	$CollisionShape2D.disabled = true
	$Sprite.hide()
	$Explosion.play('explosion')


func _ready():
	randomize()
	$Sprite.frame = randi() % 3
	var path = $EnemyPaths.get_children()[randi() % $EnemyPaths.get_child_count()]
	follow = PathFollow2D.new()
	path.add_child(follow)
	follow.loop = false


func _process(delta):
	follow.offset += speed * delta
	position = follow.global_position
	if follow.unit_offset >= 1:
		queue_free()


func _on_Explosion_animation_finished():
	queue_free()


func _on_GunTimer_timeout():
	shoot_pulse(randi() % 3 + 1, 0.3)


func _on_Enemy_body_entered(body):
	if body.name == 'Player':
		body.explode()
	if body.is_in_group('rocks'):
		body.explode()
	take_damage(1)
