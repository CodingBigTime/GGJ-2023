extends TextureButton

var peer = ENetMultiplayerPeer.new()

func _pressed():
	peer.create_server(1234)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer server.")
		return
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(
		func(new_peer_id):
			rpc("test")
	)
	$down.play()
#	get_tree().change_scene_to_file("res://scenes/online_queue_menu.tscn")

@rpc
func test():
	print("connected")

func _on_button_down():
	$down.play()


func _on_button_up():
	$up.play()


func _on_tree_exited():
	_on_button_up()
