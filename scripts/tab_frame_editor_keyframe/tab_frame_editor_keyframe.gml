/// tab_frame_editor_keyframe()

// Transition
var text = text_get("transition" + tl_edit.value[e_value.TRANSITION]);
tab_control(40)
draw_button_menu("frameeditortransition", e_menu.TRANSITION_LIST, dx, dy, dw, 40, tl_edit.value[e_value.TRANSITION], text, action_tl_frame_transition, transition_texture_small_map[?tl_edit.value[e_value.TRANSITION]])
tab_next()

// Bezier config
//tab_control_meter()
//draw_meter("frameeditorbezierconfig", dx, dy, dw,tl_edit.value[e_value.BEZIER], 60, -3, 3, 0, 0.1, tab.camera.tbx_bezierconfig, action_tl_frame_bezierconfig)
//tab_next()

// EXanimation's bezier scale coefficient
var capwid = text_caption_width("projectbezier")
tab_control_meter()
//draw_meter("projectbezier", dx, dy, dw, bezier, 50, -3, 3, 0, 0.1, tab.keyframe.tbx_bezier, action_project_bezier, capwid)
draw_meter("projectbezier", dx, dy, dw,tl_edit.value[e_value.BEZIER], 60, -3, 3, 0, 0.1, tab.keyframe.tbx_bezier, action_tl_frame_bezierconfig)
bezier = tl_edit.value[e_value.BEZIER]*100
tab_next()

if(bezier != last_bezier){
	transition_texture_map = new_transition_texture_map(60, 60, 12)
	transition_texture_small_map = new_transition_texture_map(36, 36, 2)
	last_bezier = bezier
}

// Visible
tab_control_checkbox()
draw_checkbox("frameeditorvisible", dx, dy, tl_edit.value[e_value.VISIBLE], action_tl_frame_visible)
tab_next()
