extends Node2D
class_name Player

var current_point: Point = null
var CONTROLLER_DEADZONE = 0.05

func _physics_process(delta):
	var left_stick_angle = get_joystick_direction(JOY_ANALOG_LX, JOY_ANALOG_LY)
	var right_stick_angle = get_joystick_direction(JOY_ANALOG_RX, JOY_ANALOG_RY)

	var left_stick_distance = get_joystick_distance(JOY_ANALOG_LX, JOY_ANALOG_LY)
	var right_stick_distance = get_joystick_distance(JOY_ANALOG_RX, JOY_ANALOG_RY)

	if(abs(right_stick_distance) > CONTROLLER_DEADZONE):
		print(right_stick_distance)
	if(abs(left_stick_distance) > CONTROLLER_DEADZONE):
		print(left_stick_distance)

func set_current_point(point: Point):
	current_point = point
	position = point.position

func get_joystick_direction(x, y):
	var stick_angle = Vector2(Input.get_joy_axis(0, x), Input.get_joy_axis(0, y)).angle()
	return 2*PI - (stick_angle + 2 * PI if stick_angle < 0 else stick_angle)

func get_joystick_distance(x, y):
	return  min(sqrt(pow(Input.get_joy_axis(0, x),2) + pow(Input.get_joy_axis(0, y), 2)), 1)
