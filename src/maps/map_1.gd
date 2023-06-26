extends Node2D

var num_players = 2
var resource_point_scene = preload("res://objects/resource_point.tscn")
var connector_point_scene = preload("res://objects/connector_point.tscn")
var player_scene = preload("res://actors/player.tscn")
var player_bar_scene = preload("res://ui/player_bar.tscn")

var players = []
var player_bars = []
var player_indicators = []
@onready var win_image = $win_message
@onready var bgm = $bgm

func _ready():
	var connector_points = []

	for i in range(num_players):
		connector_points.push_back(connector_point_scene.instantiate())

		if i % 2 == 0:
			connector_points[i].position = Vector2(100, get_window().get_size().y / 2.)
		else:
			connector_points[i].position = Vector2(
				get_window().get_size().x - 100, get_window().get_size().y / 2.
			)

		players.push_back(player_scene.instantiate())
		players[i].player_id = i
		players[i].set_current_point(connector_points[i])

		var player_bar = player_bar_scene.instantiate()
		var player_indicator = Sprite2D.new()
		player_indicator.set_texture(load("res://assets/p" + str(i + 1) + "_indicator.png"))
		if i == 0:
			var color = Color(0.25, 0.7, 0.13, 1)
			player_bar.set_tint_progress(color)
			player_bar.set_tint_over(color)
			player_bar.set_position(Vector2(32, 32))
			player_indicator.set_position(Vector2(32, 96))
		else:
			var color = Color(0.13, 0.44, 0.7, 1)
			player_bar.set_tint_progress(color)
			player_bar.set_tint_over(color)
			player_bar.set_position(
				Vector2(get_window().get_size().x - player_bar.get_size().x * 2 - 32, 32)
			)
			player_indicator.set_position(
				Vector2(get_window().get_size().x - player_indicator.get_texture().get_size().x, 96)
			)

		connector_points[i].set_player_owner(players[i])
		connector_points[i].set_texture(players[i])

		connector_points[i].name = str(Time.get_ticks_msec())
		players[i].name = str(Time.get_ticks_msec())
		player_bar.name = str(Time.get_ticks_msec())
		player_indicator.name = str(Time.get_ticks_msec())
		add_child(connector_points[i])
		add_child(players[i])
		add_child(player_bar)
		add_child(player_indicator)
		player_bars.push_back(player_bar)
		player_indicators.push_back(player_indicator)

	bgm.set_volume_db(-15)
	bgm.play()


func _process(_delta):
	for i in range(num_players):
		if is_instance_valid(players[i]):
			player_bars[i].value = players[i].get_points()


func announce_winner(player):
	var message = "Player " + str(player.player_id + 1) + " wins!"
	print(message)
	bgm.stop()
	win_image.set_texture(load("res://assets/p" + str(player.player_id + 1) + "_win.png"))
	win_image.visible = true
	win_image.set_position(
		Vector2(get_window().get_size().x / 2., get_window().get_size().y / 2. - 200)
	)
	$win.play()
