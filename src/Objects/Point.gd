extends Node2D
class_name Point

var _belongs_to = null
var _connections: Dictionary = {}
var connection_scene = load("res://Objects/RootPath.tscn")

func connect_point(point: Point):
	_connections[point] = create_edge(point)
	point.get_connector_points().push_back(self)


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


func get_connector_points():
	return _connections.keys()
