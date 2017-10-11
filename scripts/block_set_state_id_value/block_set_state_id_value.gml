/// block_set_state_id_value(block, stateid, name, value)
/// @arg block
/// @arg stateid
/// @arg name
/// @arg value

var block, stateid, name, val, state;
block = argument0
stateid = argument1
name = argument2
val = argument3
state = block.states_map[?name]

stateid -= ((stateid div state.value_id) mod state.value_amount) * state.value_id // Remove old
stateid += state.value_map[?val] * state.value_id // Add new

return stateid