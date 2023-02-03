extends Node2D
class_name Point

var _belongs_to = null
var _connector_points: Array = [] # Array of Points

func connect_point(point: Point):
	_connector_points.push_back(point)
	point.get_connector_points().push_back(self)

func get_connector_points():
	return _connector_points
