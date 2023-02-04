extends Point
class_name PreviewPoint

const MAXIMUM_DISTANCE = 100
const MINIMUM_DISTANCE = 25
const SNAP_DISTANCE = 25

enum State {
	HIDDEN,
	VALID_NEW_POINT,
	INVALID_NEW_POINT,
	SNAP_TO_POINT,
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
	
	for connector_point in player.current_point.get_connector_points():
		var angle = player.get_angle_to_point(connector_point)
		var preview_angle = Vector2.ZERO.angle_to_point(position)
		if abs(angle - preview_angle) < PI / 4:
			state = State.INVALID_NEW_POINT
			return

	var connector_points = []
	for node in get_node("../..").get_children():
		if node is ConnectorPoint or node is ResourcePoint:
			connector_points.push_back(node)

	var closest_distance = 1000000.0
	var new_snap = false
	for connector_point in connector_points:
		if not is_instance_valid(connector_point):
			continue
		if connector_point == player.current_point:
			continue
		var distance = (player.position + position).distance_to(connector_point.position)
		if distance < SNAP_DISTANCE:
			if distance < closest_distance:
				closest_distance = distance
				closest_point = connector_point
			state = State.SNAP_TO_POINT
			new_snap = true
	if new_snap:
		position = closest_point.position - player.position
		return
	
	state = State.VALID_NEW_POINT

func set_visible(visible: bool):
	get_node("Sprite").visible = visible
