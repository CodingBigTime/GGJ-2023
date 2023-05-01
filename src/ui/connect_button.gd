extends TextureButton

var peer = ENetMultiplayerPeer.new()

func _pressed():
	peer.create_client('localhost', 1234)
	multiplayer.multiplayer_peer = peer
	$down.play()
#	get_tree().change_scene_to_file("res://scenes/online_queue_menu.tscn")


func _on_button_up():
	$up.play()


func _on_button_down():
	$down.play()
