extends Point
class_name PreviewPoint

@export var MAXIMUM_DISTANCE = 150
@export var MINIMUM_DISTANCE = 50
@export var SNAP_DISTANCE = 35

enum State {
	HIDDEN,
	VALID_NEW_POINT,
	INVALID_NEW_POINT,
	SNAP_TO_POINT,
	SNAP_TO_ENEMY_POINT
}

var state: int = State.HIDDEN

var closest_point = null

func update_position(stick_angle: float, stick_distance: float):
	position = Vector2(
		MAXIMUM_DISTANCE * stick_distance * cos(stick_angle),
		-MAXIMUM_DISTANCE * stick_distance * sin(stick_angle)
	)

func update_state(player):
	if position.distance_to(Vector2.ZERO) < MINIMUM_DISTANCE:
		state = State.HIDDEN
		set_visible(false)
		return

	set_visible(true)

	for connector_point in player.current_point.get_connection_points():
		var angle = player.get_angle_to_point(connector_point)
		var preview_angle = Vector2.ZERO.angle_to_point(position)
		if Utils.get_abs_angle_difference(angle, preview_angle) < PI / 4:
			state = State.INVALID_NEW_POINT
			return

	var all_points = []
	for node in get_node("../..").get_children():
		if node is ConnectorPoint or node is ResourcePoint:
			all_points.push_back(node)

	var intersecting_segments = []

	for point in all_points:
		if (player.current_point == point):
			continue
		for point2 in point.get_connection_points():
			if (player.current_point == point2):
				continue
			var intersects = Utils.are_segments_intersecting(
				player.position,
				player.position + position,
				point.position,
				point2.position
			)
			if (intersects):
				intersecting_segments.push_back([point, point2])
				state = State.INVALID_NEW_POINT

	var closest_distance = INF
	var new_snap = false
	
	for point in all_points:
		var intersection_valid = true
		for segment in intersecting_segments:
			if (segment[0] != point and segment[1] != point):
				intersection_valid = false
				break
		if not intersection_valid:
			continue
		if not is_instance_valid(point):
			continue
		if point == player.current_point:
			continue
		var distance = Utils.distance_point_to_segment(
			point.position,
			player.position,
			player.position + position
		)
		if distance < SNAP_DISTANCE:
			if distance < closest_distance:
				closest_distance = distance
				closest_point = point

			if (player == point.get_player_owner() or point.get_player_owner() == null):
				state = State.SNAP_TO_POINT
			else:
				state = State.SNAP_TO_ENEMY_POINT
			new_snap = true
	if new_snap:
		set_visible(false)
		position = closest_point.position - player.position
		return
	elif (intersecting_segments.size() > 0):
		state = State.INVALID_NEW_POINT
		return
	
	var world_position = player.position + position
	if (
		world_position.x < 0
		or world_position.x > get_window().get_size().x
		or world_position.y < 0
		or world_position.y > get_window().get_size().y
	):
		state = State.INVALID_NEW_POINT
		return
	state = State.VALID_NEW_POINT

func make_spiky():
	pass

#func set_visible(visible: bool):
#	get_node("Sprite2D").visible = visible
