extends Point
class_name ResourcePoint

export var _value = 1
export var _cooldown = 1

var score = Label.new()

var timer = 0

func init(value, cooldown, pos):
	_cooldown = cooldown
	_value = value 
	get_node("..").add_child(score)
	score.set_position(pos)
	score.set_text(str(value) + " p/\n" + ("%.2f" % cooldown) + "s")
	score.set_align(Label.ALIGN_CENTER)

func _process(delta):
	timer += delta
	if not is_instance_valid(_current_owner):
		return
	if timer >= _cooldown:
		_current_owner.points += _value
		_current_owner.points = min(_current_owner.points, 50)
		timer = 0
