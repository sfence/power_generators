-------------------------------
-- Combustion engine gearbox --
-------------------------------
----- Ver 1.0 ---------
-----------------------
-- Initial Functions --
-----------------------
local S = power_generators.translator;

local _shaft_sides = {"front", "back", "top"}

power_generators.ce_gearbox = appliances.appliance:new(
    {
      node_name_inactive = "power_generators:ce_gearbox",
      node_name_active = "power_generators:ce_gearbox_active",
      
      node_description = S("Combustion engine gear box"),
    	node_help = S("Fill it with liquid fuel.").."\n"..S("Use this for generate 150 unit of energy.").."\n"..S("Startup and Shutdown by punch."),
      
      input_stack_size = 0,
      have_input = false,
      use_stack_size = 0,
      have_usage = false,
      output_stack_size = 0,
      
      power_connect_sides = {"front"},
      
      have_control = true,
      
      _shaft_sides = _shaft_sides,
      _shaft_side = "front",
      _starter_side = "top",
      _engine_side = "back",
      _friction = 10,
      _I = 90,
      
      sounds = {
        running = {
          sound = "power_generators_ce_gearbox_running",
          sound_param = {max_hear_distance = 32, gain = 1},
          repeat_timer = 1,
        },
      },
    })

local ce_gearbox = power_generators.ce_gearbox

ce_gearbox:power_data_register(
  {
    ["time_power"] = {
        run_speed = 1,
        disable = {}
      },
  })
local next_shifting = {
  ["starter"] = "neutral",
  ["neutral"] = "shaft",
  ["shaft"] = "starter",
}
ce_gearbox:control_data_register(
  {
    ["template_control"] = {
        on_punch = function(self, control, pos, node, puncher, pointed_thing)
          local meta = minetest.get_meta(pos)
          local shifting = meta:get_string("shifting")
          shifting = next_shifting[shifting]
          if shifting == "starter" then
            if meta:get_float("rpm")>0 then
              -- next to neutral
              shifting = next_shifting[shifting]
            end
          end
          meta:set_string("shifting", shifting)
          power_generators.ce_gearbox_shifting(self, pos, node, meta)
        end,
      },
  })

--------------
-- Formspec --
--------------

local player_inv = "list[current_player;main;1.5,3.5;8,4;]";
if minetest.get_modpath("hades_core") then
   player_inv = "list[current_player;main;0.5,3.5;10,4;]";
end

function ce_gearbox:get_formspec(meta, production_percent, consumption_percent)
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

local shifting_text = {
  ["starter"] = S("Starter"),
  ["neutral"] = S("Neutral"),
  ["shaft"] = S("Shaft"),
}

function ce_gearbox:get_infotext(pos, meta, state)
  return self.node_description.." - "..shifting_text[meta:get_string("shifting")]
end

function ce_gearbox:cb_on_construct(pos)
  local meta = minetest.get_meta(pos)
  meta:set_string(self.meta_infotext, self.node_description)
  
  meta:set_int("I", self._I)
  meta:set_int("Isum", self._I)
  meta:set_int("front_ratio", 0)
  meta:set_int("back_ratio", 1)
  meta:set_int("top_ratio", 0)
  meta:set_string("shifting", "neutral")
  self:call_on_construct(pos, meta)
end

function ce_gearbox:cb_on_production(timer_step)
  power_generators.shaft_step(self, timer_step.pos, timer_step.meta, timer_step.use_usage)
end

function ce_gearbox:cb_waiting(pos, meta)
  power_generators.shaft_step(self, pos, meta, nil)
end

function ce_gearbox:cb_no_power(pos, meta)
  power_generators.shaft_step(self, pos, meta, nil)
end

function ce_gearbox:cb_deactivate(pos, meta)
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
    groups = {cracky = 2, shaft = 1},
    legacy_facedir_simple = true,
    is_ground_content = false,
    sounds = node_sounds,
    drawtype = "mesh",
    mesh = "power_generators_ce_gearbox.obj",
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
        "power_generators_ce_gearbox_moving_parts.png",
    },
  }

local node_active = {
    tiles = {
        "power_generators_frame_steel.png",
        "power_generators_shaft_steel.png",
        "power_generators_body_steel.png",
        "power_generators_ce_gearbox_cable.png",
        {
          image = "power_generators_ce_gearbox_moving_parts_active.png",
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

ce_gearbox:register_nodes(node_def, node_inactive, node_active)

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

ce_gearbox:recipe_register_usage(
	items.phial_fuel,
	{
		inputs = 1,
		outputs = {items.phial_empty},
		consumption_time = 2,
		consumption_step_size = 1,
    generator_output = 150,
	});
ce_gearbox:recipe_register_usage(
	items.bottle_fuel,
	{
		inputs = 1,
		outputs = {items.bottle_empty},
		consumption_time = 20,
		consumption_step_size = 1,
    generator_output = 150,
	});
ce_gearbox:recipe_register_usage(
	items.can_fuel,
	{
		inputs = 1,
		outputs = {items.can_empty},
		consumption_time = 160,
		consumption_step_size = 1,
    generator_output = 150,
	});

ce_gearbox:register_recipes("", "power_generators_fuel")

