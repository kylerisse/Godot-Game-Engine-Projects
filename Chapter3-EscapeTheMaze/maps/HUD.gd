extends CanvasLayer


func _ready():
	$MarginContainer/ScoreLabel.text = str(Global.score)


func _process(delta):
	$MarginContainer/ScoreLabel.text = str(Global.score)
