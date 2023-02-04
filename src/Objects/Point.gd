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
	var angle = point.position.angle_to_point(position)
	var connection = connection_scene.instance()
	connection.position = point.position
	connection.rotation = PI+angle
	var sprite = connection.get_node("Sprite");
	sprite.region_enabled = true
	sprite.region_rect.end.y = sprite.texture.get_height()
	sprite.region_rect.end.x = position.distance_to(point.position)
	get_node("..").add_child(connection)
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
