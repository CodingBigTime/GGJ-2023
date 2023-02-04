extends Node2D

var rng = RandomNumberGenerator.new()

func _ready():

	var player = load("res://Actors/Player.tscn").instance()
	var connector_point_scene = load("res://Objects/ConnectorPoint.tscn")
	var resource_node_scene = load("res://Objects/ResourcePoint.tscn")
	var connector_points = [connector_point_scene.instance(), connector_point_scene.instance()]

	for i in connector_points.size():
		var point = connector_points[i]
		point.position = Vector2((i+1) * 200, 50)
		add_child(point)

	add_child(player)
	rng.randomize()
	for i in range(rng.randi_range(5, 15)):
		var resource_noce = resource_node_scene.instance()
		add_child(resource_noce)
		# 						value					cooldown
		resource_noce.init(rng.randf_range(5, 20), rng.randf_range(1, 7))
		resource_noce.position.x = rng.randf_range(50, 1000)
		resource_noce.position.y = rng.randf_range(50, 1000)
	player.set_current_point(connector_points[0])
	connector_points[0].connect_point(connector_points[1])
