extends Node2D
class_name Player

var current_point: Point = null
var CONTROLLER_DEADZONE = 0.05
var MOVE_DELAY = 0.25
var MOVEMENT_LIMIT = PI/2
var movement_delta = 1
var player_id = 0

var rng = RandomNumberGenerator.new()
var rg = Range.new()

@onready var listener = $AudioListener2D

var points = 21

var _passive_points_timer = 0.0
@export var _passive_points_amount = 1
@export var _passive_points_cooldown = 2

var preview_point: PreviewPoint = null
var preview_path: PreviewPath = null

var scale_values = [Vector2(1.5, 1.5), Vector2(2,2)]

var _bfs_effect_active = false
var _bfs_effect_timer = 0.0
var _bfs_effect_array = []
var _bfs_effect_depth = 0

func _ready():
	preview_point = load("res://Objects/PreviewPoint.tscn").instantiate()
	preview_path = load("res://Objects/PreviewPath.tscn").instantiate()
	add_child(preview_point)
	add_child(preview_path)
	preview_point.set_visible(false)
	preview_path.set_visible(false)
	start_scale_tween()
	rng.randomize()
	$AudioListener2D/root_connect.set_volume_db(-15)
	$AudioListener2D/steal_enemy.set_volume_db(-5)
	$AudioListener2D/root_connect.set_attenuation(2)
	$AudioListener2D/new_root.set_attenuation(2)
	$AudioListener2D/steal_enemy.set_attenuation(2)
	$AudioListener2D/root_connect.set_max_distance(40000)
	$AudioListener2D/new_root.set_max_distance(40000)
	$AudioListener2D/steal_enemy.set_max_distance(40000)

func update_cursor(sprite: Sprite2D):
	var sprite_text = load("res://assets/selected_player_"+str(player_id+1)+".png")
	sprite.set_texture(sprite_text)
	return sprite

func start_scale_tween():
	var sprite = get_node("Sprite2D")
	sprite = update_cursor(sprite)
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT).set_loops()
	tween.tween_property(sprite, "scale", scale_values[0], 2.0)
	tween.tween_property(sprite, "scale", scale_values[1], 2.0)
	tween.connect("finished", Callable(self, "on_scale_tween_completed"))
	tween.play()

func on_scale_tween_completed(object, key):
	scale_values.invert()
	start_scale_tween()

func _physics_process(delta):
	var left_stick_angle = Utils.get_joystick_direction(JOY_AXIS_LEFT_X, JOY_AXIS_LEFT_Y, player_id)
	var right_stick_angle = Utils.get_joystick_direction(JOY_AXIS_RIGHT_X, JOY_AXIS_RIGHT_Y, player_id)

	var left_stick_distance = Utils.get_joystick_distance(JOY_AXIS_LEFT_X, JOY_AXIS_LEFT_Y, player_id)
	var right_stick_distance = Utils.get_joystick_distance(JOY_AXIS_RIGHT_X, JOY_AXIS_RIGHT_Y, player_id)

	movement_delta += delta

	_passive_points_timer += delta

	if (_passive_points_timer >= _passive_points_cooldown):
		_passive_points_timer -= _passive_points_cooldown
		points += _passive_points_amount

	update_sprite(delta)

	if (_bfs_effect_active and _bfs_effect_array.size() > 0):
		_bfs_effect_timer += delta
		if (_bfs_effect_timer >= 0.1):
			_bfs_effect_timer -= 0.1
			while (_bfs_effect_array.size() > 0 and _bfs_effect_array[0][1] == _bfs_effect_depth):
				var point = _bfs_effect_array.pop_front()[0]
				point.modulate = Color(1.72, 1.72, 1.72, 1)
			_bfs_effect_depth += 1

	if(abs(right_stick_distance) > CONTROLLER_DEADZONE):
		var connected_points = current_point.get_connection_points()
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
		left_stick_distance if abs(left_stick_distance) > CONTROLLER_DEADZONE else 0)

	preview_point.update_state(self)
	preview_path.update_position(Vector2.ZERO, preview_point.position)

	if (Input.is_action_just_pressed("place_connector_point_p" + str(player_id+1))):
		if (preview_point.state == PreviewPoint.State.VALID_NEW_POINT) and points >= 3:
			var connector_point = load("res://Objects/ConnectorPoint.tscn").instantiate()
			get_node("..").add_child(connector_point)
			connector_point.position = position + preview_point.position
			connector_point.rotation = rng.randf_range(0, 2*PI);
			current_point.connect_point(connector_point)
			set_current_point(connector_point)
			listener.position = connector_point.position
			$AudioListener2D/new_root.set_pitch_scale(rng.randf_range(0.4, 1))
			$AudioListener2D/new_root.play()
			
			points -= 3
		elif (preview_point.state == PreviewPoint.State.SNAP_TO_POINT) and points >= 1:
			current_point.connect_point(preview_point.closest_point)
			set_current_point(preview_point.closest_point)
			listener.position = current_point.position
			$AudioListener2D/root_connect.set_pitch_scale(rng.randf_range(0.4, 1))
			$AudioListener2D/root_connect.play()
			points -= 1
		elif (preview_point.state == PreviewPoint.State.SNAP_TO_ENEMY_POINT) and points >= preview_point.closest_point.health_points:
			var connected_points = preview_point.closest_point.get_all_connected_points_dfs()
			var enemy = preview_point.closest_point.get_owner()
			var is_occupied_subgraph = enemy.current_point in connected_points
			points -= preview_point.closest_point.health_points
			$AudioListener2D/steal_enemy.set_pitch_scale(rng.randf_range(0.4, 1))
			$AudioListener2D/steal_enemy.play()
			if not is_occupied_subgraph:
				for point in connected_points:
					point.set_player_owner(self)
				current_point.connect_point(preview_point.closest_point)
				set_current_point(preview_point.closest_point)
			else:
				if (preview_point.closest_point == enemy.current_point):
					var num_connected_points = enemy.current_point.get_connection_points().size()
					if num_connected_points == 0:
						get_parent().announce_winner(self)
						enemy.queue_free()
						_bfs_effect_active = true
					else:
						var random_connected = enemy.current_point.get_connection_points()[
							randi() % num_connected_points
						]
						enemy.set_current_point(random_connected)
				preview_point.closest_point.remove_edges()
				current_point.connect_point(preview_point.closest_point)
				set_current_point(preview_point.closest_point)
				if (_bfs_effect_active):
					_bfs_effect_array = current_point.get_all_connected_points_bfs()

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

func update_sprite(delta):
	var sprite = get_node("Sprite2D")
	sprite = update_cursor(sprite)
	sprite.rotation += delta * 0.5

func min_angle(angle):
	return min(2*PI-angle, angle)
	
func abs_min_angle(angle):
	return abs(min_angle(angle))

func set_current_point(point: Point):
	current_point = point
	position = point.position
	current_point.set_player_owner(self)

func get_angle_to_point(point: Point):
	return position.angle_to_point(point.position)

func get_points():
	return points
