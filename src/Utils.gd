extends Node
class_name Utils


static func get_joystick_direction(x, y, device):
	var stick_angle = Vector2(Input.get_joy_axis(device, x), Input.get_joy_axis(device, y)).angle()
	return 2*PI - (stick_angle + 2 * PI if stick_angle < 0 else stick_angle)

static func get_joystick_distance(x, y, device):
	return min(sqrt(pow(Input.get_joy_axis(device, x),2) + pow(Input.get_joy_axis(device, y), 2)), 1)

static func get_abs_angle_difference(a, b):
	var diff = b - a
	if diff > PI:
		diff -= 2 * PI
	elif diff < -PI:
		diff += 2 * PI
	return abs(diff)
