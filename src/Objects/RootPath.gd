extends Node2D
class_name RootPath


func update_position(start:Vector2, end:Vector2) -> void:
	var angle = end.angle_to_point(start)
	position = end
	rotation = angle
	var sprite = get_node("Sprite2D");
	sprite.region_enabled = true
	sprite.region_rect.end.y = sprite.texture.get_height()
	sprite.region_rect.end.x = start.distance_to(end)


#func set_visible(visible:bool) -> void:
#	self.visible = visible
