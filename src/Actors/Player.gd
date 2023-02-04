extends Node2D
class_name Player

var current_point: Point = null
var CONTROLLER_DEADZONE = 0.05
var MOVE_DELAY = 0.25
var MOVEMENT_LIMIT = PI/2
var movement_delta = 1
var player_id = 0

var points = 0
var score_display = Label.new()

var preview_point: PreviewPoint = null
var preview_path: PreviewPath = null

var scale_values = [Vector2(1.5, 1.5), Vector2(2,2)]

func _ready():
	preview_point = load("res://Objects/PreviewPoint.tscn").instance()
	preview_path = load("res://Objects/PreviewPath.tscn").instance()
	add_child(preview_point)
	add_child(preview_path)
	preview_point.set_visible(false)
	preview_path.set_visible(false)
	get_node("..").add_child(score_display)
	score_display.set_position(Vector2(0, player_id*50))
	start_scale_tween()

func start_scale_tween():
	var sprite = get_node("Sprite")
	var tween = get_node("Tween")
	tween.interpolate_property(sprite, "scale", scale_values[0], scale_values[1], 2.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.connect("tween_completed", self, "on_scale_tween_completed")
	tween.start()

func on_scale_tween_completed(object, key):
	scale_values.invert()
	start_scale_tween()

func _physics_process(delta):
	var left_stick_angle = Utils.get_joystick_direction(JOY_ANALOG_LX, JOY_ANALOG_LY, player_id)
	var right_stick_angle = Utils.get_joystick_direction(JOY_ANALOG_RX, JOY_ANALOG_RY, player_id)

	var left_stick_distance = Utils.get_joystick_distance(JOY_ANALOG_LX, JOY_ANALOG_LY, player_id)
	var right_stick_distance = Utils.get_joystick_distance(JOY_ANALOG_RX, JOY_ANALOG_RY, player_id)

	movement_delta += delta

	update_sprite(delta)

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
				set_current_point(closest_point)

	preview_point.update_position(
		left_stick_angle,
		left_stick_distance if abs(left_stick_distance) > CONTROLLER_DEADZONE else 0
	)

	preview_point.update_state(self)
	preview_path.update_position(Vector2.ZERO, preview_point.position)

	if (Input.is_action_just_pressed("place_connector_point_p" + str(player_id+1))):
		if (preview_point.state == PreviewPoint.State.VALID_NEW_POINT):
			var connector_point = load("res://Objects/ConnectorPoint.tscn").instance()
			get_node("..").add_child(connector_point)
			connector_point.position = position + preview_point.position
			connector_point.rotation = get_node("..").rng.randf_range(0, 2*PI);
			current_point.connect_point(connector_point)
			set_current_point(connector_point)
		elif (preview_point.state == PreviewPoint.State.SNAP_TO_POINT):
			current_point.connect_point(preview_point.closest_point)
			set_current_point(preview_point.closest_point)

	if (preview_point.state == PreviewPoint.State.HIDDEN):
		preview_path.set_visible(false)
	else:
		preview_path.set_visible(true)

	if (preview_point.state != PreviewPoint.State.HIDDEN):
		var color = null
		match preview_point.state:
			PreviewPoint.State.VALID_NEW_POINT:
				color = Color(3, 3, 3, 0.4)
			PreviewPoint.State.INVALID_NEW_POINT:
				color = Color(1.5, 1, 1, 0.3)
			PreviewPoint.State.SNAP_TO_POINT:
				color = Color(3, 3, 3, 1)
			PreviewPoint.State.SNAP_TO_ENEMY_POINT:
				color = Color(10, 1, 1, 1)

		preview_path.modulate = color
		preview_point.modulate = color

	score_display.set_text("Player " + str(player_id) + ": " + str(points))

func update_sprite(delta):
	var sprite = get_node("Sprite")
	sprite.rotation += delta * 0.5

func min_angle(angle):
	return min(2*PI-angle, angle)
	
func abs_min_angle(angle):
	return abs(min_angle(angle))

func set_current_point(point: Point):
	current_point = point
	position = point.position
	current_point.set_owner(self)

func get_angle_to_point(point: Point):
	return position.angle_to_point(point.position)
