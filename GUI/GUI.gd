extends CanvasLayer

export var message_timeout = 1

onready var hit_counter = $HitCounter/Counter
onready var message_popup = $Message
onready var message_title = $Message/Label
onready var instructions = $Instructions

signal instructions_hidden

func _ready():
	instructions.popup_centered()

func _input(event):
	if Input.is_action_just_released("hit"):
		instructions.hide()
		emit_signal("instructions_hidden")

func _on_Player_hits_changed(player):
	hit_counter.set_text(str(player.hits))

func _on_Root_ui_message(message):
	message_title.set_text(message)
	message_popup.popup_centered()
	yield(get_tree().create_timer(message_timeout), "timeout")
	message_popup.hide()
