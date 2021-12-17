-------------------------
-- Emergency Generator --
-------------------------
----- Ver 1.0 ---------
-----------------------
-- Initial Functions --
-----------------------
local S = power_generators.translator;
local Cable = power_generators.electric_cable

power_generators.emergency_generator = appliances.appliance:new(
    {
      node_name_inactive = "power_generators:emergency_generator_2",
      node_name_active = "power_generators:emergency_generator_2_active",
      
      node_description = S("Emergency Generator With Controller"),
    	node_help = S("Fill it with liquid fuel.").."\n"..S("Use this for generate energy.").."\n"..S("Startup and Shutdown by punch."),
      
      input_stack_size = 0,
      have_input = false,
      
      power_connect_sides = {"front","back","right","left"},
      
      have_control = true,
      
      sounds = {
        active_running = {
          sound = "power_generators_emergency_generator_startup",
          sound_param = {max_hear_distance = 32, gain = 1},
          repeat_timer = 3,
        },
        waiting_running = {
          sound = "power_generators_emergency_generator_startup",
          sound_param = {max_hear_distance = 32, gain = 1},
          repeat_timer = 3,
        },
        running = {
          sound = "power_generators_emergency_generator_running",
          sound_param = {max_hear_distance = 32, gain = 1},
          repeat_timer = 1,
        },
        running_idle = {
          sound = "power_generators_emergency_generator_shutdown",
          sound_param = {max_hear_distance = 32, gain = 1},
        },
        running_nopower = {
          sound = "power_generators_emergency_generator_shutdown",
          sound_param = {max_hear_distance = 32, gain = 1},
        },
        running_waiting = {
          sound = "power_generators_emergency_generator_shutdown",
          sound_param = {max_hear_distance = 32, gain = 1},
        },
      },
    })

local emergency_generator = power_generators.emergency_generator

emergency_generator:power_data_register(
  {
    ["time_power"] = {
        run_speed = 1,
        disable = {}
      },
  })
emergency_generator:control_data_register(
  {
    ["punch_control"] = {
        power_off_on_deactivate = true,
      },
  })

--------------
-- Formspec --
--------------

function emergency_generator:get_formspec(meta, production_percent, consumption_percent)
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
                    "list[current_player;main;1.5,3;8,4;]" ..
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


function emergency_generator:cb_on_production(timer_step)
  power_generators.update_generator_supply(self.power_connect_sides, timer_step.pos, timer_step.use_usage)
end

function emergency_generator:cb_waiting(pos, meta)
  power_generators.update_generator_supply(self.power_connect_sides, pos, nil)
end

function emergency_generator:cb_deactivate(pos, meta)
  power_generators.update_generator_supply(self.power_connect_sides, pos, nil)
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
    {-0.0625,-0.0625,-0.5,0.0625,0.0625,-0.4375},
    {-0.3125,-0.5,-0.4375,0.3125,-0.4375,-0.375},
    {-0.375,-0.4375,-0.4375,-0.3125,0.125,-0.375},
    {0.3125,-0.4375,-0.4375,0.375,0.125,-0.375},
    {0.0,-0.0625,-0.4375,0.0625,0.0625,0.5},
    {-0.3125,0.0,-0.4375,0.0,0.0625,0.4375},
    {0.0625,0.0,-0.4375,0.3125,0.0625,0.4375},
    {-0.3125,0.125,-0.4375,0.3125,0.1875,-0.375},
    {-0.375,-0.5,-0.375,-0.3125,-0.4375,0.375},
    {0.3125,-0.5,-0.375,0.375,-0.4375,0.375},
    {0.0625,-0.4375,-0.375,0.25,-0.125,-0.3125},
    {-0.1875,-0.375,-0.375,-0.0625,-0.25,0.4375},
    {0.25,-0.1875,-0.375,0.375,-0.125,-0.3125},
    {0.0,-0.125,-0.375,0.0625,-0.0625,-0.25},
    {-0.375,0.0,-0.375,-0.3125,0.0625,0.4375},
    {0.3125,0.0,-0.375,0.375,0.0625,0.4375},
    {-0.25,-0.4375,-0.3125,0.0,-0.375,0.0},
    {0.0625,-0.4375,-0.3125,0.25,-0.1875,-0.25},
    {-0.25,-0.375,-0.3125,-0.1875,-0.1875,0.0},
    {-0.0625,-0.375,-0.3125,0.0,0.0,-0.25},
    {-0.1875,-0.25,-0.3125,-0.0625,-0.1875,0.375},
    {-0.25,-0.0625,-0.3125,-0.0625,0.0,0.3125},
    {0.0625,-0.0625,-0.3125,0.25,0.0,0.3125},
    {-0.25,0.0625,-0.3125,0.25,0.125,0.3125},
    {-0.375,-0.4375,-0.25,-0.25,-0.375,-0.1875},
    {-0.0625,-0.375,-0.25,0.0,-0.125,0.0},
    {-0.0625,-0.0625,-0.25,0.0,0.0,0.3125},
    {-0.3125,0.0625,-0.25,-0.25,0.125,0.25},
    {0.25,0.0625,-0.25,0.3125,0.125,0.25},
    {-0.25,0.125,-0.25,0.25,0.1875,0.25},
    {0.0625,-0.4375,-0.1875,0.375,-0.375,-0.125},
    {0.0,-0.375,-0.1875,0.1875,-0.3125,0.0},
    {0.0625,-0.3125,-0.1875,0.25,-0.25,0.0},
    {0.125,-0.25,-0.1875,0.1875,-0.1875,0.0},
    {-0.125,-0.1875,-0.1875,-0.0625,-0.0625,-0.125},
    {-0.0625,0.1875,-0.1875,0.0625,0.25,-0.0625},
    {0.0,-0.4375,-0.125,0.1875,-0.375,-0.0625},
    {0.0,-0.3125,-0.125,0.0625,-0.25,-0.0625},
    {-0.375,-0.4375,-0.0625,-0.25,-0.375,0.0},
    {0.0625,-0.4375,-0.0625,0.375,-0.375,0.0},
    {0.0625,-0.25,-0.0625,0.125,-0.125,0.0},
    {-0.3125,-0.1875,-0.0625,-0.0625,-0.125,0.0},
    {0.0,-0.1875,-0.0625,0.0625,-0.125,0.0},
    {0.125,-0.1875,-0.0625,0.3125,-0.125,0.0},
    {-0.3125,-0.125,-0.0625,-0.25,0.0,0.0},
    {0.25,-0.125,-0.0625,0.3125,0.0,0.0},
    {-0.5,-0.0625,-0.0625,-0.3125,0.0,0.0},
    {0.3125,-0.0625,-0.0625,0.5,0.0,0.0},
    {-0.5,0.0,-0.0625,-0.375,0.0625,0.0},
    {0.375,0.0,-0.0625,0.5,0.0625,0.0},
    {-0.1875,-0.4375,0.0,-0.0625,-0.375,0.375},
    {-0.25,-0.375,0.0,-0.1875,-0.25,0.375},
    {-0.0625,-0.375,0.0,0.0,-0.25,0.375},
    {0.125,-0.3125,0.0,0.1875,-0.25,0.375},
    {0.0625,-0.25,0.0,0.125,-0.1875,0.375},
    {-0.5,-0.0625,0.0,-0.4375,0.0625,0.0625},
    {0.4375,-0.0625,0.0,0.5,0.0625,0.0625},
    {-0.375,-0.4375,0.0625,-0.1875,-0.375,0.125},
    {0.125,-0.4375,0.0625,0.375,-0.375,0.125},
    {0.0625,-0.375,0.0625,0.25,-0.3125,0.375},
    {0.0625,-0.3125,0.0625,0.125,-0.25,0.375},
    {0.1875,-0.3125,0.0625,0.25,-0.25,0.375},
    {0.125,-0.25,0.0625,0.1875,-0.1875,0.375},
    {0.125,-0.4375,0.125,0.1875,-0.375,0.375},
    {-0.1875,-0.5,0.3125,-0.0625,-0.4375,0.4375},
    {0.125,-0.5,0.3125,0.1875,-0.4375,0.4375},
    {-0.375,-0.25,0.3125,-0.1875,-0.1875,0.375},
    {0.0,-0.25,0.3125,0.0625,-0.0625,0.375},
    {0.1875,-0.25,0.3125,0.375,-0.1875,0.375},
    {-0.3125,-0.5,0.375,-0.1875,-0.4375,0.4375},
    {-0.0625,-0.5,0.375,0.125,-0.4375,0.4375},
    {0.1875,-0.5,0.375,0.3125,-0.4375,0.4375},
    {-0.375,-0.4375,0.375,-0.3125,0.0,0.4375},
    {0.3125,-0.4375,0.375,0.375,0.0,0.4375},
    {-0.375,0.0625,0.375,-0.3125,0.125,0.4375},
    {0.3125,0.0625,0.375,0.375,0.125,0.4375},
    {-0.3125,0.125,0.375,0.3125,0.1875,0.4375},
    {-0.0625,-0.0625,0.4375,0.0,0.0625,0.5},
  },
}

local node_def = {
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {cracky = 2, power_generator = 1},
    legacy_facedir_simple = true,
    is_ground_content = false,
    sounds = node_sounds,
    drawtype = "mesh",
    mesh = "power_generators_emergency_generator.obj",
    use_texture_alpha = "clip",
    collision_box = node_box,
    selection_box = node_box,
 }

local node_inactive = {
    tiles = {
        "power_generators_emergency_generator_frame_lid_hose.png",
        "power_generators_emergency_generator_front_panel_body.png",
        "power_generators_emergency_generator_back_body.png",
        "power_generators_emergency_generator_tank.png",
        "power_generators_emergency_generator_cable.png",
        "power_generators_emergency_generator_moving_parts.png",
    },
  }

local node_active = {
    tiles = {
        "power_generators_emergency_generator_frame_lid_hose.png",
        "power_generators_emergency_generator_front_panel_body.png",
        "power_generators_emergency_generator_back_body.png",
        "power_generators_emergency_generator_tank.png",
        "power_generators_emergency_generator_cable.png",
        {
          image = "power_generators_emergency_generator_moving_parts_active.png",
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

emergency_generator:register_nodes(node_def, node_inactive, node_active)

Cable:add_secondary_node_names({emergency_generator.node_name_active, emergency_generator.node_name_inactive})
--Cable:add_special_node_names({name})
Cable:set_valid_sides(emergency_generator.node_name_active, {"R", "L", "F", "B"})
Cable:set_valid_sides(emergency_generator.node_name_inactive, {"R", "L", "F", "B"})

-------------------------
-- Recipe Registration --
-------------------------

local items = {
  phial_fuel = "biofuel:phial_fuel",
  phial_empty = "biofuel:phial",
  bottle_fuel = "biofuel:bottle_fuel",
  bottle_empty = "vessels:glass_bottle",
  can_fuel = "biofuel:fuel_can",
  can_empty = "biofuel:can",
}

if minetest.get_modpath("hades_biofuel") then
  items.phial_fuel = "hades_biofuel:phial_fuel"
  items.phial_empty = "hades_biofuel:phial"
  items.bottle_fuel = "hades_biofuel:bottle_fuel"
  items.bottle_empty = "vessels:glass_bottle"
  items.can_fuel = "hades_biofuel:fuel_can"
  items.can_empty = "hades_biofuel:can"
end

-- hope, temporary only support for biofuel withou vessels manageent
if not minetest.registered_items[items.phial_empty] then
  items.phial_empty = nil
  items.bottle_empty = nil
  items.can_empty = nil
end

emergency_generator:recipe_register_usage(
	items.phial_fuel,
	{
		inputs = 1,
		outputs = {items.phial_empty},
		consumption_time = 2,
		consumption_step_size = 1,
    generator_output = 200,
	});
emergency_generator:recipe_register_usage(
	items.bottle_fuel,
	{
		inputs = 1,
		outputs = {items.bottle_empty},
		consumption_time = 22,
		consumption_step_size = 1,
    generator_output = 200,
	});
emergency_generator:recipe_register_usage(
	items.can_fuel,
	{
		inputs = 1,
		outputs = {items.can_empty},
		consumption_time = 176,
		consumption_step_size = 1,
    generator_output = 200,
	});

emergency_generator:register_recipes("", "power_generators_fuel")

