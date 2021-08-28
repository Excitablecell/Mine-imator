/// app_event_create()
/// @desc Entry point of the application.

globalvar debug_indent, debug_timer;
debug_indent = 0
debug_info = false
globalvar bezier,last_bezier;
bezier = 3
last_bezier = bezier

enums()
randomize()
gml_release_mode(true)

if (!app_startup())
{
	game_end()
	return 0
}