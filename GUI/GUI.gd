extends CanvasLayer

export var message_timeout = 1

onready var hit_counter = $HitCounter/Counter
onready var message_popup = $Message
onready var message_title = $Message/Label

func _on_Player_hits_changed(player):
	hit_counter.set_text(str(player.hits))

func _on_Root_ui_message(message):
	message_title.set_text(message)
	message_popup.popup_centered()
	yield(get_tree().create_timer(message_timeout), "timeout")
	message_popup.hide()
