extends Node2D
class_name Player

var current_point: Point = null
var CONTROLLER_DEADZONE = 0.05
var MOVE_DELAY = 0.25
var MOVEMENT_LIMIT = PI/2
var movement_delta = 1

var points = 0
var score_display = Label.new()

var preview_point: PreviewPoint = null

func _ready():
	preview_point = load("res://Objects/PreviewPoint.tscn").instance()
	add_child(preview_point)
	preview_point.set_visible(false)
	get_node("..").add_child(score_display)
	score_display.set_position(Vector2(0, 0))

func _physics_process(delta):
	var left_stick_angle = Utils.get_joystick_direction(JOY_ANALOG_LX, JOY_ANALOG_LY)
	var right_stick_angle = Utils.get_joystick_direction(JOY_ANALOG_RX, JOY_ANALOG_RY)

	var left_stick_distance = Utils.get_joystick_distance(JOY_ANALOG_LX, JOY_ANALOG_LY)
	var right_stick_distance = Utils.get_joystick_distance(JOY_ANALOG_RX, JOY_ANALOG_RY)

	movement_delta += delta

	if(abs(right_stick_distance) > CONTROLLER_DEADZONE):
		var connected_points = current_point.get_connector_points()
		if connected_points.size() > 0 and movement_delta >= MOVE_DELAY:
			movement_delta = 0
			var closest_point = null
			var min_angle = 1000
			for point in connected_points:
				var current_angle = Utils.get_abs_angle_difference(-point.position.angle_to_point(current_point.position), right_stick_angle)
				if current_angle < min_angle && current_angle < MOVEMENT_LIMIT:
					closest_point = point
					min_angle = current_angle
			if (closest_point != null):
				print(min_angle)
				set_current_point(closest_point)

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
	score_display.set_text("Score: " + str(points))


func min_angle(angle):
	return min(2*PI-angle, angle)
	
func abs_min_angle(angle):
	return abs(min_angle(angle))

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

func get_angle_to_point(point: Point):
	return position.angle_to_point(point.position)
