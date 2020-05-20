extends Spatial

export(Array, PackedScene) var levels = []

signal ui_message

var current_level = 0
var scene: Node

func start_level(level):
	if scene != null:
		scene.queue_free()
	
	scene = levels[level].instance()
	add_child(scene)

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().reload_current_scene()


func _ready():
	start_level(current_level)


func _on_Player_fail():
	start_level(current_level)
	emit_signal("ui_message", "Fail!")


func _on_Player_win(player):
	var suffix = ''
	if (player.hits != 1):
		suffix = 's'
	current_level += 1
	
	if current_level >= levels.size():
		emit_signal("ui_message", str("Complete!\n", player.hits, ' hit', suffix))
	else:
		emit_signal("ui_message", str("Nice!\n", player.hits, ' hit', suffix))
		start_level(current_level)
