extends Node

onready var player = get_node('/root/Root/Player')
onready var start = $Start
onready var hole_group = $Holes

var hole_collider = preload("res://Components/HoleCollider.tscn")


func match_pos(source: Node, dest: Node):
	source.set_transform(dest.get_global_transform())


func _ready():
	match_pos(player, start)
	player.set_axis_velocity(Vector3())
	player.set_mode(RigidBody.MODE_STATIC)
	player.set_mode(RigidBody.MODE_RIGID)

	var holes: Array = hole_group.get_children()
	for hole in holes:
		var col = hole_collider.instance()
		col.connect("body_entered", player, "win")
		match_pos(col, hole)
		add_child(col)
