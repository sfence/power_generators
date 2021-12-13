
power_generators = {
  translator = minetest.get_translator("power_generators")
}

local modpath = minetest.get_modpath(minetest.get_current_modname())

dofile(modpath.."/electric_network.lua")
dofile(modpath.."/power_supply.lua")
--dofile(modpath.."/electric_junction.lua")

appliances.register_craft_type("power_generators_fuel", {
    description = "Generator fuel",
    icon = "power_generators_fuel_recipe_icon.png",
    width = 1,
    height = 1,
  })

dofile(modpath.."/functions.lua")

dofile(modpath.."/emergency_generator.lua")
dofile(modpath.."/emergency_generator_2.lua")

dofile(modpath.."/craftitems.lua")
dofile(modpath.."/crafting.lua")

