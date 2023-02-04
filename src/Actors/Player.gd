extends Node2D
class_name Player

var current_point: Point = null
var CONTROLLER_DEADZONE = 0.05

var points = 0

var preview_point: PreviewPoint = null

func _ready():
	preview_point = load("res://Objects/PreviewPoint.tscn").instance()
	add_child(preview_point)
	preview_point.set_visible(false)

func _physics_process(delta):
	var left_stick_angle = get_joystick_direction(JOY_ANALOG_LX, JOY_ANALOG_LY)
	var right_stick_angle = get_joystick_direction(JOY_ANALOG_RX, JOY_ANALOG_RY)

	var left_stick_distance = get_joystick_distance(JOY_ANALOG_LX, JOY_ANALOG_LY)
	var right_stick_distance = get_joystick_distance(JOY_ANALOG_RX, JOY_ANALOG_RY)

#	if(abs(right_stick_distance) > CONTROLLER_DEADZONE):
#		print(right_stick_distance)

	preview_point.update_position(
		left_stick_angle,
		left_stick_distance if abs(left_stick_distance) > CONTROLLER_DEADZONE else 0
	)

	preview_point.update_state(self)

	if (preview_point.state == PreviewPoint.State.VALID_NEW_POINT):
		if (Input.is_action_just_pressed("place_connector_point")): 
			var connector_point = load("res://Objects/ConnectorPoint.tscn").instance()
			get_node("..").add_child(connector_point)
			connector_point.position = position + preview_point.position
			current_point.connect_point(connector_point)
			set_current_point(connector_point)
	elif (preview_point.state == PreviewPoint.State.SNAP_TO_POINT):
		if (Input.is_action_just_pressed("place_connector_point")): 
			current_point.connect_point(preview_point.closest_point)
			set_current_point(preview_point.closest_point)
			current_point.set_owner(self)

	if (Input.is_action_just_pressed("remove_node")):
		current_point.get_connector_points()[0].remove_edges()
		
	update()

func _draw():
	if (preview_point.state != PreviewPoint.State.HIDDEN):
		var color = Color(255, 255, 255)
		match preview_point.state:
			PreviewPoint.State.VALID_NEW_POINT:
				color = Color(0, 255, 0)
			PreviewPoint.State.INVALID_NEW_POINT:
				color = Color(255, 0, 0)
			PreviewPoint.State.SNAP_TO_POINT:
				color = Color(0, 0, 255)
		draw_line(Vector2.ZERO, preview_point.position, color, 3)

func set_current_point(point: Point):
	current_point = point
	position = point.position

func get_joystick_direction(x, y):
	var stick_angle = Vector2(Input.get_joy_axis(0, x), Input.get_joy_axis(0, y)).angle()
	return 2*PI - (stick_angle + 2 * PI if stick_angle < 0 else stick_angle)

func get_joystick_distance(x, y):
	return min(sqrt(pow(Input.get_joy_axis(0, x),2) + pow(Input.get_joy_axis(0, y), 2)), 1)

func get_angle_to_point(point: Point):
	return position.angle_to_point(point.position)
