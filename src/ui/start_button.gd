extends TextureButton


func _pressed():
	$down.play()
	get_tree().change_scene_to_file("res://scenes/maps/map_1.tscn")


func _on_button_down():
	$down.play()


func _on_button_up():
	$up.play()
