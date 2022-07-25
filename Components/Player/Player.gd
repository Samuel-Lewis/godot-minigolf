extends RigidBody

export var strength := 2.5
export var strength_max := 2.5
export var power_up_speed := 1.5
export var reset_height := -3.0
export var fail_timeout := 0.5

signal hits_changed
signal fail
signal win
signal power_up(value)

onready var ball_anchor = get_node('/root/Root/BallAnchor')

var is_grounded := false # set by ray cast publically
var hits := 0
var ready_to_hit := false # tells us when we can hit so we don't hit ball while its rolling

func _ready():
	emit_signal("hits_changed", self)
	
func _physics_process(_delta):
	if ball_anchor.get_global_transform().origin.y < reset_height:
		emit_signal("fail")
	
	# attempt to stop ball from rolling so much
	if not ready_to_hit and is_grounded and get_linear_velocity().length_squared() < 0.01:
		linear_velocity = Vector3.ZERO
		sleeping = true
		ready_to_hit = true

func _process(delta : float):
	if not ready_to_hit:
		return
	
	if Input.is_action_just_pressed("hit"):
		strength = 0
	if Input.is_action_pressed("hit"):
		strength += delta * power_up_speed
		strength = clamp(strength, 0, strength_max)
		emit_signal("power_up", strength / strength_max)
	if Input.is_action_just_released("hit"):
		hit()


func hit():
	sleeping = false
	var forward: Vector3 = ball_anchor.get_global_transform().basis.z
	forward = forward.normalized() * -strength
	apply_central_impulse(forward)
	hits += 1
	emit_signal("hits_changed", self)
	
	# little timer to stop ball from instantly stopping when hit
	yield(get_tree().create_timer(0.5), "timeout")
	ready_to_hit = false

func win(player):
	emit_signal("win", player)
