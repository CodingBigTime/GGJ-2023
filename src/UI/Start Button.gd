extends TextureButton

func _pressed():
	$down.play()
	get_tree().change_scene("res://Maps/map_1.tscn")

func _on_Start_Button_button_down():
	$down.play()

func _on_Start_Button_button_up():
	$up.play()
