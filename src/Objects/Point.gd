extends Node2D
class_name Point

var _current_owner = null
var _connections: Dictionary = {}
var connection_scene = load("res://Objects/RootPath.tscn")
var health_points = 1
var is_spikey = false

func make_spikey(point: Point):
	point.get_node('SpikeSprite').visible = true
	health_points = 3
	is_spikey = true

func connect_point(point: Point,player_id: int):
	var root_path = create_edge(point, player_id)
	_connections[point] = root_path
	point._connections[self] = root_path
	if "score" in self:
		point.make_spikey(point)
	elif "score" in point:
		make_spikey(self)

func create_edge(point: Point, player_id: int):
	var connection = connection_scene.instance()
	var connection_texture = preload("res://assets/Connections/player_4_vine.png")
	match player_id:
		0:
			connection_texture = preload("res://assets/Connections/player_1_vine.png")
		1:
			connection_texture = preload("res://assets/Connections/player_2_vine.png")
		2:
			connection_texture = preload("res://assets/Connections/player_3_vine.png")
		3:
			connection_texture = preload("res://assets/Connections/player_4_vine.png")
	
	connection.get_node("Sprite").set_texture(connection_texture)
	get_node("..").add_child(connection)
	connection.update_position(position, point.position)
	return connection

func remove_edges():
	for k in get_connection_points():
		remove_edge(k)

func remove_edge(point: Point):
	if point in _connections:
		_connections[point].queue_free()
		_connections.erase(point)
		point.remove_edge(self)

func get_connection_points():
	var keys = []
	for key in _connections.keys():
		if is_instance_valid(key):
			keys.append(key)
	return keys

func get_connection_path(key):
	if is_instance_valid(_connections[key]):
		return _connections[key]

func set_owner(player):
	_current_owner = player
	if not '_cooldown' in self:
		set_texture(_current_owner)

func set_texture(player):
	var player_texture = load("res://assets/players/" + str(player.player_id + 1) + ".png")
	get_node('Sprite').set_texture(player_texture)

func get_owner():
	return _current_owner

func get_all_connected_points():
	var stack = []
	var visited = {}
	var points = []
	stack.append(self)
	while stack.size() > 0:
		var point = stack.pop_front()
		if point in visited:
			continue
		visited[point] = true
		points.append(point)
		for connected_point in point.get_connection_points():
			stack.append(connected_point)
	return points
