
-------------------------
-- Combustion engine --
-------------------------
----- Ver 1.0 ---------
-----------------------
-- Initial Functions --
-----------------------
local S = power_generators.translator;

local _shaft_sides = {"front"}

power_generators.electric_engine_200 = appliances.appliance:new(
    {
      node_name_inactive = "power_generators:electric_engine_200",
      node_name_active = "power_generators:electric_engine_200_active",
      
      node_description = S("Electric engine"),
    	node_help = S("Connect to power (@1).","200 EU").."\n"..S("Use this for generata shaft torque.").."\n"..S("Startup and Shutdown by punch.").."\n"..S("Can be greased."),
      
      input_stack_size = 0,
      have_input = false,
      use_stack_size = 0,
      have_usage = false,
      
      power_connect_sides = {"back","right","left"},
      _shaft_sides = _shaft_sides,
      _friction = 10,
      _maxT = 20000,
      -- maxP per step is (maxT/I)*I
      _maxP = 20000*2000,
      _limitRpm = 3000,
      _I = 20,
      
      _qgrease_max = 2,
      _qgrease_eff = 1,
      
      have_control = true,
      
      sounds = {
        active_running = {
          sound = "power_generators_electric_engine_200_running",
          sound_param = {max_hear_distance = 16, gain = 1},
          repeat_timer = 3,
        },
        waiting_running = {
          sound = "power_generators_electric_engine_200_running",
          sound_param = {max_hear_distance = 16, gain = 1},
          repeat_timer = 3,
        },
        running = {
          sound = "power_generators_electric_engine_200_running",
          sound_param = {max_hear_distance = 16, gain = 1},
          repeat_timer = 1,
        },
      },
    })

local electric_engine_200 = power_generators.electric_engine_200

electric_engine_200:power_data_register(
  {
    ["LV_power"] = {
        demand = 200,
        run_speed = 1,
        disable = {}
      },
    ["power_generators_electric_power"] = {
        demand = 200,
        run_speed = 1,
        disable = {}
      },
  })
electric_engine_200:control_data_register(
  {
    ["punch_control"] = {
        power_off_on_deactivate = true,
      },
  })

--------------
-- Formspec --
--------------

local player_inv = "list[current_player;main;1.5,3.5;8,4;]";
if minetest.get_modpath("hades_core") then
   player_inv = "list[current_player;main;0.5,3.5;10,4;]";
end

function electric_engine_200:get_formspec(meta, production_percent, consumption_percent)
  local progress = "";
  
  progress = "image[3.6,0.9;5.5,0.95;appliances_consumption_progress_bar.png^[transformR270]]";
  if consumption_percent then
    progress = "image[3.6,0.9;5.5,0.95;appliances_consumption_progress_bar.png^[lowpart:" ..
            (consumption_percent) ..
            ":appliances_consumption_progress_bar_full.png^[transformR270]]";
  end
  
  
  
  local formspec =  "formspec_version[3]" .. "size[12.75,8.5]" ..
                    "background[-1.25,-1.25;15,10;appliances_appliance_formspec.png]" ..
                    progress..
                    player_inv ..
                    "list[context;"..self.use_stack..";2,0.8;1,1;]"..
                    "list[context;"..self.output_stack..";9.75,0.25;2,2;]" ..
                    "listring[current_player;main]" ..
                    "listring[context;"..self.use_stack.."]" ..
                    "listring[current_player;main]" ..
                    "listring[context;"..self.output_stack.."]" ..
                    "listring[current_player;main]";
  return formspec;
end

---------------
-- Callbacks --
---------------

function electric_engine_200:cb_on_construct(pos)
  local meta = minetest.get_meta(pos)
  meta:set_string(self.meta_infotext, self.node_description)
  
  meta:set_int("I", self._I)
  meta:set_int("Isum", self._I)
  meta:set_int("front_ratio", 1)
  meta:set_int("front_engine", 1)
  self:call_on_construct(pos, meta)
end

electric_engine_200.get_torque = power_generators.ee_get_torque

function electric_engine_200:cb_on_production(timer_step)
  power_generators.update_shaft_supply(self, timer_step.pos, timer_step.meta, timer_step.speed)
  power_generators.shaft_step(self, timer_step.pos, timer_step.meta, timer_step.use_usage)
end

function electric_engine_200:cb_waiting(pos, meta)
  power_generators.shaft_step(self, pos, meta, nil)
end

function electric_engine_200:cb_no_power(pos, meta)
  power_generators.shaft_step(self, pos, meta, nil)
end

function electric_engine_200:cb_deactivate(pos, meta)
  power_generators.shaft_step(self, pos, meta, nil)
end

----------
-- Node --
----------

local node_sounds = nil
if minetest.get_modpath("default") then
  node_sounds = default.node_sound_metal_defaults()
end
if minetest.get_modpath("hades_sounds") then
  node_sounds = hades_sounds.node_sound_metal_defaults()
end
if minetest.get_modpath("sounds") then
  node_sounds = sounds.node_metal()
end
  
-- node box {x=0, y=0, z=0}
local node_box = {
  type = "fixed",
  fixed = {
    {-0.5,-0.5,-0.5,-0.375,0.5,-0.375},
    {0.375,-0.5,-0.5,0.5,0.5,-0.375},
    {-0.0625,-0.0625,-0.5,0.0625,0.0625,0.5},
    {-0.375,-0.125,-0.4375,0.375,-0.0625,-0.375},
    {-0.125,-0.0625,-0.4375,-0.0625,0.125,0.4375},
    {0.0625,-0.0625,-0.4375,0.125,0.125,0.4375},
    {-0.375,0.0625,-0.4375,-0.125,0.125,-0.375},
    {-0.0625,0.0625,-0.4375,0.0625,0.125,0.4375},
    {0.125,0.0625,-0.4375,0.375,0.125,-0.375},
    {-0.125,-0.25,-0.375,0.125,-0.0625,0.375},
    {-0.1875,-0.1875,-0.375,-0.125,0.1875,0.375},
    {0.125,-0.1875,-0.375,0.1875,0.1875,0.375},
    {-0.4375,-0.125,-0.375,-0.375,-0.0625,0.5},
    {-0.25,-0.125,-0.375,-0.1875,0.125,0.375},
    {0.1875,-0.125,-0.375,0.25,0.125,0.375},
    {0.375,-0.125,-0.375,0.4375,-0.0625,0.5},
    {-0.4375,0.0625,-0.375,-0.375,0.125,0.5},
    {0.375,0.0625,-0.375,0.4375,0.125,0.5},
    {-0.125,0.125,-0.375,0.125,0.25,0.375},
    {-0.4375,-0.0625,-0.125,-0.375,0.0625,0.125},
    {0.375,-0.0625,-0.125,0.4375,0.0625,0.125},
    {-0.5,-0.0625,-0.0625,-0.4375,0.0625,0.0625},
    {0.4375,-0.0625,-0.0625,0.5,0.0625,0.0625},
    {-0.375,0.0,0.0,-0.25,0.0625,0.0625},
    {0.25,0.0,0.0,0.375,0.0625,0.0625},
    {-0.5,-0.5,0.375,-0.375,-0.125,0.5},
    {0.375,-0.5,0.375,0.5,-0.125,0.5},
    {-0.5,-0.125,0.375,-0.4375,0.5,0.5},
    {-0.375,-0.125,0.375,0.375,-0.0625,0.4375},
    {0.4375,-0.125,0.375,0.5,0.5,0.5},
    {-0.4375,-0.0625,0.375,-0.375,0.0625,0.5},
    {0.375,-0.0625,0.375,0.4375,0.0625,0.5},
    {-0.375,0.0625,0.375,-0.125,0.125,0.4375},
    {0.125,0.0625,0.375,0.375,0.125,0.4375},
    {-0.4375,0.125,0.375,-0.375,0.5,0.5},
    {0.375,0.125,0.375,0.4375,0.5,0.5},
  },
}

local node_def = {
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {cracky = 2, shaft = 1, greasable = 1},
    legacy_facedir_simple = true,
    is_ground_content = false,
    sounds = node_sounds,
    drawtype = "mesh",
    mesh = "power_generators_shaft_ee_small.obj",
    use_texture_alpha = "clip",
    collision_box = node_box,
    selection_box = node_box,
    
    _shaft_sides = _shaft_sides,
 }

local node_inactive = {
    tiles = {
        "power_generators_frame_steel.png",
        "power_generators_shaft_steel.png",
        "power_generators_body_steel.png",
        "power_generators_electric_cable.png",
        "power_generators_electric_engine_200_cable.png",
        "power_generators_electric_engine_200_moving_parts.png",
    },
  }

local node_active = {
    tiles = {
        "power_generators_frame_steel.png",
        "power_generators_shaft_steel.png",
        "power_generators_body_steel.png",
        "power_generators_electric_cable.png",
        "power_generators_electric_engine_200_cable.png",
        {
          image = "power_generators_electric_engine_200_moving_parts_active.png",
          backface_culling = false,
          animation = {
            type = "vertical_frames",
            aspect_w = 16,
            aspect_h = 16,
            length = 1.5
          }
        }
    },
  }

electric_engine_200:register_nodes(node_def, node_inactive, node_active)

-------------------------
-- Recipe Registration --
-------------------------

