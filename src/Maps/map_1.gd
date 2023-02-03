extends Node2D

func _ready():
	var player = load("res://Actors/Player.tscn").instance()
	var connector_point_scene = load("res://Objects/ConnectorPoint.tscn")
	var connector_points = [connector_point_scene.instance(), connector_point_scene.instance()]
	for i in connector_points.size():
		var point = connector_points[i]
		point.position = Vector2((i+1) * 200, 50)
		add_child(point)

	add_child(player)
	player.set_current_point(connector_points[0])
	connector_points[0].connect_point(connector_points[1])
