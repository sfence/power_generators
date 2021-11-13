
function power_generators.update_generator_supply(self, pos, use_usage)
  local side_data = {};
  local total_demand = 0;
  for _,side in pairs(self.power_connect_sides) do
    local side_pos = appliances.get_side_pos(pos, side);
    local side_node = minetest.get_node(side_pos);
    local side_def = minetest.registered_nodes[side_node.name];
    if side_def and side_def._generator_connect_sides then
      if appliances.is_connected_to(side_pos, pos, side_def._generator_connect_sides) then
        local meta = minetest.get_meta(side_pos);
        local demand = meta:get_int("generator_demand") or 0
        if (demand>0) then
          total_demand = total_demand + demand;
          table.insert(side_data, {meta=meta,demand=demand});
        else
          meta:set_int("generator_input", 0)
        end
      end
    end
  end
  
  if (total_demand>0) then
    local generator_output = 0;
    if use_usage then
      generator_output = use_usage.generator_output or 150;
    end
    local part = generator_output/total_demand;
    
    for _,side in pairs(side_data) do
      side.meta:set_int("generator_input", math.floor(side.demand*part))
    end
  end
end

