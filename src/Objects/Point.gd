extends Node2D
class_name Point

var _current_owner = null
var _connections: Dictionary = {}
var connection_scene = load("res://Objects/RootPath.tscn")

func connect_point(point: Point):
	var root_path = create_edge(point)
	_connections[point] = root_path
	point.get_connections()[self] = root_path

func create_edge(point: Point):
	var connection = connection_scene.instance()
	get_node("..").add_child(connection)
	connection.update_position(position, point.position)
	return connection

func remove_edges():
	for k in get_connector_points():
		remove_edge(k)
		k.remove_edge(self)

	self.queue_free()

func remove_edge(point: Point):
	_connections[point].queue_free()

func get_connector_points():
	var keys = []
	for key in _connections.keys():
		if is_instance_valid(key):
			keys.append(key)
	return keys

func get_connections():
	return _connections

func set_owner(player):
	_current_owner = player
