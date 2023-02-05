extends Node2D

var num_players = 2
var resource_point_scene = load("res://Objects/ResourcePoint.tscn")
var connector_point_scene = load("res://Objects/ConnectorPoint.tscn")
var player_scene = load("res://Actors/Player.tscn")
var player_bar_scene = load("res://Objects/PlayerBar.tscn")

var players = []
var player_bars = []

func _ready():
	var connector_points = []

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

		var player_bar = player_bar_scene.instance()
		if(i == 0):
			var color = Color(0.25, 0.7, 0.13, 1)
			player_bar.set_position(Vector2(32, 32))
			player_bar.set_tint_progress(color)
			player_bar.set_tint_over(color)
		else:
			player_bar.set_position(Vector2(OS.get_window_size().x - player_bar.get_size().x * 2 - 32, 32))
			var color = Color(0.13, 0.44, 0.7, 1)
			player_bar.set_tint_progress(color)
			player_bar.set_tint_over(color)

		connector_points[i].set_owner(players[i])
		connector_points[i].set_texture(players[i])

		add_child(players[i])
		add_child(player_bar)
		player_bars.push_back(player_bar)

	add_child(load("res://Objects/Background.tscn").instance())

func _process(delta):
	for i in range(num_players):
		if is_instance_valid(players[i]):
			player_bars[i].value = players[i].get_points()
