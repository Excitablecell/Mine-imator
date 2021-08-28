/// action_project_bezier(value, add)
/// @arg value
/// @arg add

var val, add;
add = false

if (history_undo)
	val = history_data.old_value
else if (history_redo)
	val = history_data.new_value
else
{
	val = argument0
	add = argument1
	history_set_var(action_project_bezier, bezier, bezier * add + val, 1)
}

bezier = bezier * add + val
tl_update_length()
