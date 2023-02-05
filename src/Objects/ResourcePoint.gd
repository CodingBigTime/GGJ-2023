extends Point
class_name ResourcePoint

var _value = 1
var _cooldown = 1
var _amount = 10

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
	if timer >= _cooldown:
		if _current_owner == null:
			return
		else:
			_current_owner.points += _value
			_current_owner.points = min(_current_owner.points, 50)
		timer = 0
