extends Node

export (PackedScene) var Rock
export (PackedScene) var Enemy

var screensize = Vector2()

var level = 0
var score = 0 setget set_score
var playing = false


func new_game():
	$Music.play()
	for rock in $Rocks.get_children():
		rock.queue_free()
	for enemy in $Enemies.get_children():
		enemy.queue_free()
	level = 0
	score = 0
	set_score(score)
	$HUD.show_message("Get Ready!")
	yield($HUD/MessageTimer, "timeout")
	$Player.start()
	playing = true
	new_level()


func new_level():
	level += 1
	$HUD.show_message("Wave %s" % level)
	for _i in range(level):
		spawn_rock(int(rand_range(2, 3)))
	$EnemyTimer.wait_time = rand_range(5, 10)
	$EnemyTimer.start()


func game_over():
	$Music.stop()
	playing = false
	$HUD.game_over()

func set_score(value):
	if not $Player.state in ['INVULNERABLE', 'DEAD']:
		score = value
		$HUD.update_score(score)


func _ready():
	randomize()
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize


func _process(_delta):
	if playing and $Rocks.get_child_count() == 0:
		new_level()


func _on_Player_shoot(bullet, pos, dir):
	var b = bullet.instance()
	b.start(pos, dir)
	add_child(b)


func spawn_rock(size, pos = null, vel = null):
	if ! pos:
		$RockPath/RockSpawn.set_offset(randi())
		pos = $RockPath/RockSpawn.position
	if ! vel:
		vel = Vector2(1, 0).rotated(rand_range(0, 2 * PI)) * rand_range(100, 150)
	var r = Rock.instance()
	r.screensize = screensize
	r.start(pos, vel, size)
	$Rocks.add_child(r)
	r.connect('exploded', self, '_on_Rock_exploded')


func on_Enemy_exploded():
	self.score += 2


func _on_Rock_exploded(size, radius, pos, vel):
	self.score += 1
	$ExplodeSound.play()
	if size <= 1:
		return
	for offset in [-1, 1]:
		var dir = (pos - $Player.position).normalized().tangent() * offset
		var newpos = pos + dir * radius
		var newvel = dir * vel.length() * 1.1
		spawn_rock(size - 1, newpos, newvel)


func _input(event):
	if event.is_action_pressed('pause'):
		if not playing:
			return
		get_tree().paused = not get_tree().paused
		if get_tree().paused:
			$HUD/MessageLabel.text = "Paused"
			$HUD/MessageLabel.show()
		else:
			$HUD/MessageLabel.text = ""
			$HUD/MessageLabel.hide()
	if event.is_action_pressed('music'):
		if $Music.playing:
			$Music.stop()
		else:
			$Music.play()


func _on_EnemyTimer_timeout():
	$EnemySound.play()
	var e = Enemy.instance()
	$Enemies.add_child(e)
	e.target = $Player
	e.connect('shoot', self, '_on_Player_shoot')
	e.connect('exploded', self, '_on_Enemy_exploded')
