/// project_save_timeline()

json_save_object_start()

	json_save_var("id", save_id)
	json_save_var("type", type)
	json_save_var("name", json_string_encode(name))
	
	json_save_var_save_id("temp", temp)
	json_save_var("text", json_string_encode(text))
	json_save_var_color("color", color)
	json_save_var_bool("hide", hide)
	json_save_var_bool("lock", lock)
	json_save_var("depth", depth)
	
	if (type = "bodypart")
		json_save_var("model_part_name", model_part_name)
		
	if (part_of != null)
	{
		if (type = "spblock")
		{
			json_save_object_start("model")
				json_save_var("name", model_name)
				json_save_var_state_vars("state", model_state)
			json_save_object_done()
		}
		else if (type = "block")
		{
			json_save_object_start("block")
				json_save_var("name", block_name)
				json_save_var_state_vars("state", block_state)
			json_save_object_done()
		}
		
		json_save_var_save_id("part_of", part_of)
	}
	
	if (part_list != null)
	{
		json_save_array_start("parts")
		
			for (var p = 0; p < ds_list_size(part_list); p++)
				json_save_array_value(save_id_get(part_list[|p]))
		
		json_save_array_done()
	}
	
	project_save_values("default_values", value_default, app.value_default)
	
	json_save_object_start("keyframes")
	
		for (var k = 0; k < ds_list_size(keyframe_list); k++)
			with (keyframe_list[|k])
				project_save_values(string(position), value, other.value_default)

	json_save_object_done()
	
	json_save_var_save_id("parent", parent)
	json_save_var("parent_tree_index", ds_list_find_index(parent.tree_list, id))
	
	if (value_type[e_value_type.HIERARCHY])
	{
		json_save_var_bool("lock_bend", lock_bend)
		json_save_var_bool("tree_extend", tree_extend)
	
		json_save_object_start("inherit")
			json_save_var_bool("position", inherit_position)
			json_save_var_bool("rotation", inherit_rotation)
			json_save_var_bool("scale", inherit_scale)
			json_save_var_bool("alpha", inherit_alpha)
			json_save_var_bool("color", inherit_color)
			json_save_var_bool("texture", inherit_texture)
			json_save_var_bool("visibility", inherit_visibility)
			json_save_var_bool("rot_point", inherit_rot_point)
		json_save_object_done()
	
		json_save_var_bool("scale_resize", scale_resize)
	}
	
	if (value_type[e_value_type.ROT_POINT])
	{
		json_save_var_bool("rot_point_custom", rot_point_custom)
		json_save_var_point3D("rot_point", rot_point)
	}
	
	if (value_type[e_value_type.GRAPHICS])
	{
		json_save_var_bool("backfaces", backfaces)
		json_save_var_bool("texture_blur", texture_blur)
		json_save_var_bool("texture_filtering", texture_filtering)
		if (type = "bodypart")
			json_save_var_bool("round_bending", round_bending)
		json_save_var_bool("shadows", shadows)
		json_save_var_bool("ssao", ssao)
		json_save_var_bool("fog", fog)
	
		if (type = "scenery" || type = "block" || type = "particles" || type = "text" || type_is_shape(type))
		{
			json_save_var_bool("wind", wind)
			json_save_var_bool("wind_terrain", wind_terrain)
		}
	}
	
json_save_object_done()