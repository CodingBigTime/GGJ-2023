extends Point
class_name ResourcePoint

var _value = 1
var _cooldown = 1
var _amount = 10
var timer = 0


func init(value, cooldown):
	_cooldown = cooldown
	_value = int(clamp(value * cooldown, 1, 50)) 


func _process(delta):
	timer += delta
	if timer >= _cooldown:
		if _current_owner == null:
			return
		else:
			_current_owner.points += _value
		print(_current_owner.points)
#		print(timer)
#		print(_value)
		timer = 0
