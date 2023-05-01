extends TextureButton


func _pressed():
	$down.play()
	get_tree().change_scene_to_file("res://scenes/online_menu.tscn")


func _on_button_down():
	$down.play()


func _on_button_up():
	$up.play()


func _on_tree_exited():
	_on_button_up()
