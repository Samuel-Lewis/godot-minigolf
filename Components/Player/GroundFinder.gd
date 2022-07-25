extends RayCast

"""
Probably could be done better but this class is to 
ensure the ray cast is always at the ball origin position
without being affected by the balls rotation
the raycast could always be pointing down
"""

export(NodePath) var _player_node_path
var _player_node : RigidBody

func _ready():
	_player_node = get_node(_player_node_path) as RigidBody

func _physics_process(delta):
	transform.origin = _player_node.transform.origin
	_player_node.is_grounded = is_colliding()
