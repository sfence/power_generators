--------------------
-- Test Generator --
--------------------
----- Ver 1.0 ---------
-----------------------
-- Initial Functions --
-----------------------
local S = power_generators.translator;
local Cable = power_generators.electric_cable

power_generators.test_generator = appliances.appliance:new(
    {
      node_name_inactive = "power_generators:test_generator",
      node_name_active = "power_generators:test_generator_active",
      
      node_description = S("Test Generator"),
    	node_help = S("Use this for generate 10k unit of energy.").."\n"..S("Startup and Shutdown by punch."),
      
      input_stack_size = 0,
      have_input = false,
      use_stack_size = 0,
      have_usage = false,
      
      power_connect_sides = {"front","back","right","left"},
      
      have_control = true,
    })

local test_generator = power_generators.test_generator

test_generator:power_data_register(
  {
    ["time_power"] = {
        run_speed = 1,
        disable = {}
      },
  })
test_generator:control_data_register(
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

function test_generator:get_formspec(meta, production_percent, consumption_percent)
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


function test_generator:cb_on_production(timer_step)
  local use_usage = {
    generator_output = 10000,
  }
  power_generators.update_generator_supply(self.power_connect_sides, timer_step.pos, use_usage)
end

function test_generator:cb_waiting(pos, meta)
  power_generators.update_generator_supply(self.power_connect_sides, pos, nil)
end

function test_generator:cb_deactivate(pos, meta)
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
  
local node_def = {
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {cracky = 2, power_generator = 1},
    legacy_facedir_simple = true,
    is_ground_content = false,
    sounds = node_sounds,
    drawtype = "normal",
    tiles = {
      "power_generators_test_generator_side.png",
      "power_generators_test_generator_side.png",
      "power_generators_test_generator_side.png",
      "power_generators_test_generator_side.png",
      "power_generators_test_generator_side.png",
      "power_generators_test_generator_side.png",
    },
 }

test_generator:register_nodes(node_def, nil, nil)

Cable:add_secondary_node_names({test_generator.node_name_active, test_generator.node_name_inactive})
--Cable:add_special_node_names({name})
Cable:set_valid_sides(test_generator.node_name_active, {"R", "L", "F", "B", "U", "D"})
Cable:set_valid_sides(test_generator.node_name_inactive, {"R", "L", "F", "B", "U", "D"})

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

test_generator:recipe_register_usage(
	items.phial_fuel,
	{
		inputs = 1,
		outputs = {items.phial_empty},
		consumption_time = 2,
		consumption_step_size = 1,
    generator_output = 150,
	});
test_generator:recipe_register_usage(
	items.bottle_fuel,
	{
		inputs = 1,
		outputs = {items.bottle_empty},
		consumption_time = 20,
		consumption_step_size = 1,
    generator_output = 150,
	});
test_generator:recipe_register_usage(
	items.can_fuel,
	{
		inputs = 1,
		outputs = {items.can_empty},
		consumption_time = 160,
		consumption_step_size = 1,
    generator_output = 150,
	});

test_generator:register_recipes("", "power_generators_fuel")
