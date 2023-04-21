extends Control


func _show():
	super.show()  #important when overriding
	set_process_input(true)

	# grab focus of the first node
	$MarginContainer/HSplitContainer/VBoxContainer/VBoxContainer/StartButton.grab_focus()


func _hide():
	super.hide()  #important when overriding
	set_process_input(false)  #disable input for this node


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
