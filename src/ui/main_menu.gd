extends Node

var menus: Array[Node]
var maps: Array[PackedScene] = [preload("res://maps/map_1.tscn")]
var peer = ENetMultiplayerPeer.new()
var tst = preload("res://Testscene.tscn")

func _ready():
	menus = [
		$HomeMenu,
		$OnlineMenu
	]

@rpc("any_peer", "call_local")
func test(new_peer_id=0):
	print(str(new_peer_id) + " connected")
	var label = tst.instantiate()
	label.text = str(new_peer_id)
	$OnlineMenu/QueueVBox/TextEdit.hide()
	$OnlineMenu/QueueVBox/CenterContainer.hide()
	$OnlineMenu/QueueVBox/MultiplayerVBox.show()
	$OnlineMenu/QueueVBox/MultiplayerVBox/VBoxContainer.add_child(label)

func _on_host_button_pressed():
	peer.create_server(1234)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer server.")
		return
	multiplayer.multiplayer_peer = peer

	multiplayer.peer_connected.connect(test)
	test(multiplayer.get_unique_id())

	var label = tst.instantiate()
	label.text = "Connected:"

	var startButton = Button.new()
	startButton.pressed.connect(_on_start_button_pressed)
	startButton.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	startButton.text = "Start"

	$OnlineMenu/QueueVBox/TextEdit.hide()
	$OnlineMenu/QueueVBox/CenterContainer.hide()
	$OnlineMenu/QueueVBox/MultiplayerVBox.show()
	$OnlineMenu/QueueVBox/MultiplayerVBox/VBoxContainer.add_child(startButton)
	$OnlineMenu/QueueVBox/MultiplayerVBox/VBoxContainer.add_child(label)

func _on_connect_button_pressed():
	peer.create_client('localhost', 1234)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(test)
	multiplayer.connected_to_server.connect(func(): test(multiplayer.get_unique_id()))

func _on_start_button_pressed():
	hide_all_menus()
	$"..".add_child(maps[0].instantiate())

func _on_online_button_pressed():
	open_online_menu()

func _on_exit_button_pressed():
	get_tree().quit()

func _on_button_down():
	$"../ButtonDownSFX".play()

func _on_button_up():
	$"../ButtonUpSFX".play()

func open_online_menu():
	hide_all_menus()
	$OnlineMenu.show()
	
func open_main_menu():
	hide_all_menus()
	$HomeMenu.show()

func hide_all_menus():
	for menu in menus:
		menu.hide()

func _input(event):
	var current = get_viewport().gui_get_focus_owner()
	if not current:  #should not happen but in case it does
		return

	if event is InputEventJoypadMotion:
		print("axis")
		print(event.axis)
#		if event.axis == JOY_AXIS_1: #vertical left stick
#			if event.axis_value == -1.0: #full motion up
#				var prev = get_node(current.focus_previous)
#				prev.grab_focus()
#			elif event.axis_value == 1.0: # full motion down
#				var next = get_node(current.focus_next)
#				next.grab_focus()

	if event is InputEventJoypadButton:
		print("button")
		print(event.button_index)
#		#the confirmation button is pressed
#		#this will be JOY_SONY_X Playstation JOY_XBOX_A on Xbox
#		if event.button_index == JOY_BUTTON_0 and event.pressed:
#			if current is Button:
#				current._pressed() # emulate button press
#				#current.emit_signal("pressed") #emulate button press
