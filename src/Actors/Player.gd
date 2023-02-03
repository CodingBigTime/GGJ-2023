extends Node2D
class_name Player

enum Mode {
	SELECTION,
	CLAIMING
}

var mode = Mode.SELECTION
var current_point: Point = null

func _physics_process(delta):
	if mode == Mode.SELECTION:
		if Input.is_action_just_released("switch_node"):
			set_current_point(current_point.get_connector_points()[0])

func set_current_point(point: Point):
	current_point = point
	position = point.position
