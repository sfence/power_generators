
local power_supply = {
    is_powered = function (self, power_data, pos, meta)
        local I = meta:get_int("I");
        local L = meta:get_int("L")
        local rpm = L/I
        
        local demand = power_data.demand or power_data.get_demand(self, pos, meta)
        if (rpm>=demand) then
          return power_data.run_speed;
        end
        return 0;
      end,
    power_need = function (self, power_data, pos, meta)
      end,
    power_idle = function (self, power_data, pos, meta)
      end,
    on_production = function (self, power_data, timer_step)
        power_generators.shaft_step(self, timer_step.pos, timer_step.meta, timer_step.use_usage)
      end,
    waiting = function (self, power_data, pos, meta)
        power_generators.shaft_step(self, pos, meta, nil)
      end,
    no_power = function (self, power_data, pos, meta)
        power_generators.shaft_step(self, pos, meta, nil)
      end,
    update_node_def = function(self, power_data, node_def)
        node_def.groups.shaft = 1;
        node_def._shaft_sides = self.power_connect_sides;
        self._shaft_sides = self.power_connect_sides
        node_def._I = power_data.I
        self._I = power_data.I
      end,
    on_construct = function(self, power_data, pos, meta)
        meta:set_int("I", power_data.I)
        meta:set_int("Isum", power_data.I)
        for _,side in pairs(self._shaft_sides) do
          meta:set_int(side.."_ratio", 1)
        end
        meta:set_float("friction", power_data.friction)
      end,
  }
appliances.add_power_supply("power_generators_shaft_power", power_supply)

