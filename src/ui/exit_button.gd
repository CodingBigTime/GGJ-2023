extends TextureButton


func _pressed():
	get_tree().quit(-1)


func _on_button_down():
	$down.play()


func _on_button_up():
	$up.play()
