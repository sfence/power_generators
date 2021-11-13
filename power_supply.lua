
-- register power supply to power generators

local power_supply = {
    is_powered = function (self, power_data, pos, meta)
        local eu_input = meta:get_int("generator_input");
        if (eu_input>=power_data.demand) then
          return power_data.run_speed;
        end
        return 0;
      end,
    power_need = function (self, power_data, pos, meta)
        meta:set_int("generator_demand", power_data.demand)
      end,
    power_idle = function (self, power_data, pos, meta)
        meta:set_int("generator_demand", 0)
      end,
    update_node_def = function(self, power_data, node_def)
        node_def.groups.generator_powered = 1;
        node_def._generator_connect_sides = self.power_connect_sides;
      end,
  }
appliances.add_power_supply("power_generators_power", power_supply)

function power_generators.need_power(pos, gen_pos)
  local node = minetest.get_node(pos);
  if (minetest.get_item_group(node.name, "generator_powered")>0) then
    
  end
  return 0;
end

-- abm function
minetest.register_abm({
    label = "Check generator powered appliances",
    nodenames = {"group:generator_powered"},
    interval = 1,
    chance = 1,
    action = function(pos, node)
      local node_def = minetest.registered_nodes[node.name]
      for _,side in pairs(node_def._generator_connect_sides) do
        local side_pos = appliances.get_side_pos(pos, side);
        local side_node = minetest.get_node(side_pos);
        if minetest.get_item_group(side_node.name, "power_generator")>0 then
          return
        end
      end
      local meta = minetest.get_meta(pos)
      meta:set_int("generator_input", 0)
    end,
 })

