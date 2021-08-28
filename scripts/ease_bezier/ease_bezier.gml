/// ease(function, x, bezierconfig)
/// @arg function
/// @arg x
/// @desc http://www.easings.net

var function, xx, xx2, xxm1, b;
function = argument0
xx = argument1
xx2 = xx * 2
xxm1 = xx - 1
b = argument2


//show_debug_message(bezier)

if (xx <= 0)
	return 0
if (xx >= 1)
	return 1

switch (function)
{
	
	case "easebezier":
	{
		return (xx2-(xx*xx)*2) * b + xx*xx
	}
}

return xx
