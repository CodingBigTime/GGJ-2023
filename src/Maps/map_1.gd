extends Node2D

var rng = RandomNumberGenerator.new()
var num_players = 2

func _ready():
	var player_scene = load("res://Actors/Player.tscn")
	var connector_point_scene = load("res://Objects/ConnectorPoint.tscn")
	var resource_point_scene = load("res://Objects/ResourcePoint.tscn")
	var connector_points = []

	var players = []
	for i in range(num_players):

		connector_points.push_back((connector_point_scene.instance()))

		if(i % 2 == 0):
			connector_points[i].position = Vector2( 100 , OS.get_window_size().y/2)
		else:
			connector_points[i].position = Vector2( OS.get_window_size().x - 100 , OS.get_window_size().y/2)

		add_child(connector_points[i])

		players.push_back(player_scene.instance())
		players[i].player_id = i
		players[i].set_current_point(connector_points[i])

		connector_points[i].set_owner(players[i])
		connector_points[i].set_texture(players[i])

		add_child(players[i])

	add_child(load("res://Objects/Background.tscn").instance())
	rng.randomize()

	for _i in range(rng.randi_range(5, 15)):
		var resource_point = resource_point_scene.instance()
		add_child(resource_point)
		var posx = rng.randf_range(50, 1920)
		var posy = rng.randf_range(50, 1080)
		resource_point.init(rng.randi_range(5, 20), rng.randf_range(1, 7), Vector2(posx, posy))
		resource_point.position.x = posx+16
		resource_point.position.y = posy-16
