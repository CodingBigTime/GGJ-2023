extends Point
class_name ResourcePoint

var _current_owner: Player = null
var _value = 1
var _cooldown = 1
var _amount = 10
var timer = 0


func init(value, cooldown):
	_cooldown = cooldown
	_value = clamp(value * cooldown, 1, 50) 

func gain_ownership(player):
	_current_owner = player
	
func _process(delta):
	timer += delta
	if timer >= _cooldown:
		if _current_owner == null:
			pass
		else:
			_current_owner.points += _value
		print(timer)
		print(_value)
		timer = 0
