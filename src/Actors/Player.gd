extends Node2D
class_name Player

var current_point: Point = null

func _physics_process(delta):
	var left_stick_angle = get_joystick_direction(JOY_ANALOG_LX)
	var right_stick_angle = get_joystick_direction(JOY_ANALOG_RX)

	var left_stick_distance = get_joystick_distance(JOY_ANALOG_LX)
	var right_stick_distance = get_joystick_distance(JOY_ANALOG_RX)

func set_current_point(point: Point):
	current_point = point
	position = point.position

func get_joystick_direction(stick: int):
	var stick_angle = Vector2(Input.get_joy_axis(0, stick), Input.get_joy_axis(0, stick)).angle()
	return 2*PI - (stick_angle + 2 * PI if stick_angle < 0 else stick_angle)

func get_joystick_distance(stick: int):
	return Vector2(Input.get_joy_axis(0, stick), Input.get_joy_axis(0, stick))
