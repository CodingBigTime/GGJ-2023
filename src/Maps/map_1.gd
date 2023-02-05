extends Node2D

var num_players = 2
var resource_point_scene = load("res://Objects/ResourcePoint.tscn")
var connector_point_scene = load("res://Objects/ConnectorPoint.tscn")
var player_scene = load("res://Actors/Player.tscn")

func _ready():
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
