extends Position3D

export var x_sensitivity = 0.01
export var y_sensitivity = 0.005

onready var target = get_node('/root/Root/Player')
onready var camera_anchor = $CameraAnchor

var rot_x = 0
var rot_y = 0

func _init():
	set_as_toplevel(true)
	set_process_unhandled_input(true)
	
func _input(event):
	if event is InputEventMouseMotion and event.button_mask & 2:
		rot_x += event.relative.x * x_sensitivity
		rot_y += event.relative.y * y_sensitivity
		rot_y = clamp(rot_y, -0.3, 0.7)
		transform.basis = Basis()
		rotate_object_local(Vector3(0, 1, 0), rot_x)
		rotate_object_local(Vector3(1, 0, 0), rot_y)

func _ready():
	var forward: Transform = target.get_global_transform().basis
	set_global_transform(forward)
	

func _physics_process(delta):
	# Position anchor at ball origin (ignore rotation)
	var t = target.get_global_transform().origin
	var base = get_global_transform().basis
	set_global_transform(Transform(base, t))
	
	# Point camera anchor towards ball origin
	camera_anchor.look_at(t, Vector3.UP)
