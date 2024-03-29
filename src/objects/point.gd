extends Node2D
class_name Point

var _current_owner = null
var _connections: Dictionary = {}
var connection_scene = load("res://objects/root_path.tscn")
var health_points = 5
var is_spiky = false

var scale_values = [Vector2(0.85, 0.85), Vector2(1.1, 1.1)]


func start_spike_tween():
	var tween = (
		get_tree()
		. create_tween()
		. set_trans(Tween.TRANS_SINE)
		. set_ease(Tween.EASE_IN_OUT)
		. set_loops()
	)
	var sprite = get_node("SpikeSprite")
	tween.tween_property(sprite, "scale", scale_values[0], 0.5)
	tween.tween_property(sprite, "scale", scale_values[1], 0.5)
	tween.play()


func make_spiky():
	if not has_node("SpikeSprite"):
		return
	get_node("SpikeSprite").visible = true
	health_points = 9
	is_spiky = true
	start_spike_tween()


func connect_point(point: Point):
	var root_path = create_edge(point)
	_connections[point] = root_path
	point._connections[self] = root_path
	if "score" in self:
		point.make_spiky()
	elif "score" in point:
		make_spiky()


func create_edge(point: Point):
	var connection = connection_scene.instantiate()
	var player_id = get_player_owner().player_id
	var connection_texture = load(
		"res://assets/connections/player_" + str(player_id + 1) + "_vine.png"
	)
	connection.get_node("Sprite2D").set_texture(connection_texture)
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


func set_player_owner(player):
	_current_owner = player
	if not "_cooldown" in self:
		set_texture(_current_owner)
	var connection_texture = load(
		"res://assets/connections/player_" + str(_current_owner.player_id + 1) + "_vine.png"
	)
	for edge in _connections.values():
		edge.get_node("Sprite2D").set_texture(connection_texture)


func set_texture(player):
	var player_texture = load("res://assets/players/" + str(player.player_id + 1) + ".png")
	get_node("Sprite2D").set_texture(player_texture)


func get_player_owner():
	return _current_owner


func get_all_connected_points_dfs():
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


func get_all_connected_points_bfs():
	var queue = [[self, 0]]
	var visited = {}
	var points = []
	while queue.size() > 0:
		var t = queue.pop_front()
		var point = t[0]
		var depth = t[1]
		if point in visited:
			continue
		points.push_back([point, depth])
		visited[point] = true
		for connected_point in point.get_connection_points():
			queue.push_back([connected_point, depth + 1])
	return points
