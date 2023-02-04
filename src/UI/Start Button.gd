extends TextureButton

# Called when the node enters the scene tree for the first time.
func _pressed():
	get_tree().change_scene("res://Maps/map_1.tscn")
