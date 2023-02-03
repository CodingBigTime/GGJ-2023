extends Point
class_name PreviewPoint


func update_position(stick_angle: float, stick_distance: float):
	if stick_distance == 0:
		set_visible(false)
	else:
		set_visible(true)
	position = Vector2(100 * stick_distance * cos(stick_angle), -100 * stick_distance * sin(stick_angle))


func set_visible(visible: bool):
	get_node("Sprite").visible = visible
