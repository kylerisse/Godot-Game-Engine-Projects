extends Node2D

var screensize = Vector2()

func _ready():
	$AnimatedSprite.frame = rand_range(0, 10)
	$Tween.interpolate_property($AnimatedSprite, 'scale',
								$AnimatedSprite.scale,
								$AnimatedSprite.scale * 3, 0.3,
								Tween.TRANS_QUAD,
								Tween.EASE_IN_OUT)
	$Tween.interpolate_property($AnimatedSprite, 'modulate',
								Color(1, 1, 1, 1),
								Color(1, 1, 1, 0), 0.3,
								Tween.TRANS_QUAD,
								Tween.EASE_IN_OUT)
	
func pickup():
	#monitoring = false
	$Tween.start()

func _on_RigidBody2D_body_entered(body):
	pickup()


func _on_Tween_tween_completed(object, key):
	queue_free()
