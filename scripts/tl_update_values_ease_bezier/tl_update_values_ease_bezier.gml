/// tl_update_values_ease_bezier(valueid, transition, percent, bezierconfig)
/// @arg valueid
/// @arg transition
/// @arg percent

var vid, trans, p, val, b;
vid = argument0
trans = argument1
p = argument2
b = argument3

if (keyframe_current != null && keyframe_next != null && keyframe_current != keyframe_next)
	val = tl_value_interpolate(vid, ease_bezier(trans, p, b), keyframe_current.value[vid], keyframe_next.value[vid])
else if (keyframe_next != null)
	val = keyframe_next.value[vid]
else
	val = value_default[vid]

if (value[vid] != val)
	update_matrix = true

value[vid] = val
