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

static func are_segments_intersecting(start1, end1, start2, end2):
	var d = (end1.x - start1.x) * (end2.y - start2.y) - (end1.y - start1.y) * (end2.x - start2.x)
	if d == 0:
		return false
	var u = ((start2.x - start1.x) * (end2.y - start2.y) - (start2.y - start1.y) * (end2.x - start2.x)) / d
	var v = ((start2.x - start1.x) * (end1.y - start1.y) - (start2.y - start1.y) * (end1.x - start1.x)) / d
	return u > 0 and u < 1 and v > 0 and v < 1

static func distance_point_to_segment(point: Vector2, segment_start: Vector2, segment_end: Vector2) -> float:
	var a = segment_end - segment_start
	var b = point - segment_start
	var t = b.dot(a) / a.dot(a)
	if t < 0:
		t = 0
	elif t > 1:
		t = 1
	var projection = segment_start + a * t
	return point.distance_to(projection)
