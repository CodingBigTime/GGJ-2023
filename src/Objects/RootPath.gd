extends Node2D
class_name RootPath


func update_position(start:Vector2, end:Vector2) -> void:
	var angle = start.angle_to_point(end)
	position = end
	rotation = angle
	var sprite = get_node("Sprite");
	sprite.region_enabled = true
	sprite.region_rect.end.y = sprite.texture.get_height()
	sprite.region_rect.end.x = start    .distance_to(end)


func set_visible(visible:bool) -> void:
	self.visible = visible
