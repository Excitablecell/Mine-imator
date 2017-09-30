/// history_restore_scenery()
/// @desc Restores old generated timelines in the scenery.

// Restore parts
for (var t = 0; t < part_amount; t++)
{
	var tl = history_restore_tl(part_save_obj[t]);
	ds_list_add(tl.part_of.part_list, tl)
}
			
// Restore child positions in tree
for (var m = 0; m < part_child_amount; m++) 
	with (save_id_find(part_child_save_id[m]))
		tl_set_parent(save_id_find(history_data.part_child_parent_save_id[m]), history_data.part_child_parent_tree_index[m])
		
// Restore selection
history_restore_tl_select()