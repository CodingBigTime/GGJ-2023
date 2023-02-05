extends Node2D

var num_players = 2
var resource_point_scene = load("res://Objects/ResourcePoint.tscn")
var connector_point_scene = load("res://Objects/ConnectorPoint.tscn")
var player_scene = load("res://Actors/Player.tscn")
var player_bar_scene = load("res://Objects/PlayerBar.tscn")
var player_indicator_scene = load("res://Objects/PlayerIndicator.tscn")

var players = []
var player_bars = []
var player_indicators = []
onready var win_image = $win_message
onready var bgm = $bgm

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
		var player_indicator = player_indicator_scene.instance()
		player_indicator.get_node("Sprite").set_texture(load("res://assets/p" + str(i+1) + "_indicator.png"))
		if(i == 0):
			var color = Color(0.25, 0.7, 0.13, 1)
			player_bar.set_tint_progress(color)
			player_bar.set_tint_over(color)
			player_bar.set_position(Vector2(32, 32))
			player_indicator.set_position(Vector2(32, 96))
		else:
			var color = Color(0.13, 0.44, 0.7, 1)
			player_bar.set_tint_progress(color)
			player_bar.set_tint_over(color)
			player_bar.set_position(Vector2(OS.get_window_size().x - player_bar.get_size().x * 2 - 32, 32))
			player_indicator.set_position(Vector2(OS.get_window_size().x - player_indicator.get_node("Sprite").get_texture().get_size().x, 96))

		connector_points[i].set_owner(players[i])
		connector_points[i].set_texture(players[i])

		add_child(players[i])
		add_child(player_bar)
		add_child(player_indicator)
		player_bars.push_back(player_bar)
		player_indicators.push_back(player_indicator)

	add_child(load("res://Objects/Background.tscn").instance())
	bgm.set_volume_db(-15)
	bgm.play()

func _process(delta):
	for i in range(num_players):
		if is_instance_valid(players[i]):
			player_bars[i].value = players[i].get_points()

func announce_winner(player):
	var message = "Player " + str(player.player_id+1) + " wins!"
	print(message)
	bgm.stop()
	win_image.set_texture(load("res://assets/p" + str(player.player_id + 1) + "_win.png"))
	win_image.visible = true
	win_image.set_position(Vector2(OS.get_window_size().x/2, OS.get_window_size().y/2 - 200))
	$win.play()
