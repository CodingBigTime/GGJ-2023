extends Node2D
class_name Player

var current_point: Point = null
var CONTROLLER_DEADZONE = 0.05

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
