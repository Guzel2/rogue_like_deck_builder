extends Node2D

var available_space = 70
var x_offset = 30
var y_offset = 220

func organize_cards():
	var children = get_children()
	
	var x = children.size()
	
	while x > 0:
		var child = children.pop_front()
		
		if !child.action_on_desired_pos == 'remove':
			children.append(child)
		
		x -= 1
	
	print(children)
	
	var step_size = available_space / children.size()
	
	for child in children.size():
		children[child].desired_pos = Vector2(x_offset, y_offset) + Vector2(step_size*child, 0)
		children[child].start_pos = children[child].desired_pos
		children[child].action_on_desired_pos = null
